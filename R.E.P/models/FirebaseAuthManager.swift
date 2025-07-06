//
//  FirebaseAuthManager.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import LocalAuthentication

class FirebaseAuthManager: ObservableObject {
    static let shared = FirebaseAuthManager()
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let auth: Auth
    private let firestoreService = FirestoreService.shared
    private let isFirebaseAvailable: Bool
    
    init() {
        // Check if Firebase is properly configured
        if FirebaseApp.app() != nil {
            self.auth = Auth.auth()
            self.isFirebaseAvailable = true
            
            // Listen for authentication state changes
            auth.addStateDidChangeListener { [weak self] _, firebaseUser in
                DispatchQueue.main.async {
                    self?.isAuthenticated = firebaseUser != nil
                    
                    // Fetch app user from Firestore if Firebase user exists
                    if let uid = firebaseUser?.uid {
                        Task {
                            do {
                                let appUser = try await self?.firestoreService.getUser(uid: uid)
                                DispatchQueue.main.async {
                                    self?.currentUser = appUser
                                }
                            } catch {
                                print("Error fetching user from Firestore: \(error)")
                                DispatchQueue.main.async {
                                    self?.currentUser = nil
                                }
                            }
                        }
                    } else {
                        self?.currentUser = nil
                    }
                }
            }
        } else {
            // Firebase not configured, create a dummy auth instance
            self.auth = Auth.auth()
            self.isFirebaseAvailable = false
            print("Warning: Firebase not configured. Authentication features will not work.")
        }
    }
    
    // MARK: - Email/Password Authentication
    
    func signIn(email: String, password: String) async throws -> Bool {
        guard isFirebaseAvailable else {
            await MainActor.run {
                self.errorMessage = "Firebase is not configured. Please set up Firebase properly."
                self.isLoading = false
            }
            throw NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase not configured"])
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            
            // Fetch app user from Firestore
            let appUser = try await firestoreService.getUser(uid: result.user.uid)
            
            await MainActor.run {
                self.currentUser = appUser
                self.isAuthenticated = true
                self.isLoading = false
            }
            return true
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            throw error
        }
    }
    
    func signUp(email: String, password: String, registrationUser: RegistrationUser) async throws -> Bool {
        guard isFirebaseAvailable else {
            await MainActor.run {
                self.errorMessage = "Firebase is not configured. Please set up Firebase properly."
                self.isLoading = false
            }
            throw NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase not configured"])
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Print final registration user state
            registrationUser.printProperties(context: "FirebaseAuthManager - Final Registration State")
            
            // Create Firebase Auth user
            let result = try await auth.createUser(withEmail: email, password: password)
            
            // Validate registration data
            guard registrationUser.isComplete else {
                let errors = registrationUser.validationErrors.joined(separator: ", ")
                throw NSError(domain: "Registration", code: -1, userInfo: [NSLocalizedDescriptionKey: "Registration incomplete: \(errors)"])
            }
            
            // Create user document in Firestore
            let user = registrationUser.toUser(uid: result.user.uid)
            
            try await firestoreService.createUser(user)
            
            await MainActor.run {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
            }
            return true
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            throw error
        }
    }
    
    func signOut() throws {
        do {
            try auth.signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            throw error
        }
    }
    
    func resetPassword(email: String) async throws {
        guard isFirebaseAvailable else {
            await MainActor.run {
                self.errorMessage = "Firebase is not configured. Please set up Firebase properly."
                self.isLoading = false
            }
            throw NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase not configured"])
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await auth.sendPasswordReset(withEmail: email)
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            throw error
        }
    }
    
    // MARK: - User Profile Management
    
    func updateUserProfile(displayName: String? = nil, photoURL: URL? = nil) async throws {
        guard let firebaseUser = auth.currentUser else { return }
        
        let changeRequest = firebaseUser.createProfileChangeRequest()
        if let displayName = displayName {
            changeRequest.displayName = displayName
        }
        if let photoURL = photoURL {
            changeRequest.photoURL = photoURL
        }
        
        try await changeRequest.commitChanges()
    }
    
    func deleteAccount() async throws {
        guard let firebaseUser = auth.currentUser else { return }
        
        try await firebaseUser.delete()
        currentUser = nil
        isAuthenticated = false
    }
    
    // MARK: - User Data Management
    
    func saveUserData(_ userData: [String: Any]) async throws {
        guard isFirebaseAvailable else {
            throw NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase not configured"])
        }
        guard let user = currentUser else { return }
        
        let db = Firestore.firestore()
        try await db.collection("users").document(user.uid).setData(userData, merge: true)
    }
    
    func getUserData() async throws -> [String: Any]? {
        guard isFirebaseAvailable else {
            throw NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase not configured"])
        }
        guard let user = currentUser else { return nil }
        
        let db = Firestore.firestore()
        let document = try await db.collection("users").document(user.uid).getDocument()
        return document.data()
    }
    
    // MARK: - Face ID Authentication
    
    func authenticateWithFaceID() async throws -> Bool {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw NSError(domain: "FaceID", code: -1, userInfo: [NSLocalizedDescriptionKey: "Face ID not available"])
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Sign in to your account") { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }
} 
