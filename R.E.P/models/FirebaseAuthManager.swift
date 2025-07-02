//
//  FirebaseAuthManager.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import Foundation
import Firebase
import FirebaseAuth
import LocalAuthentication

class FirebaseAuthManager: ObservableObject {
    static let shared = FirebaseAuthManager()
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let auth: Auth
    private let keychainService = "com.rep.app.firebase"
    private let isFirebaseAvailable: Bool
    
    init() {
        // Check if Firebase is properly configured
        if FirebaseApp.app() != nil {
            self.auth = Auth.auth()
            self.isFirebaseAvailable = true
            
            // Listen for authentication state changes
            auth.addStateDidChangeListener { [weak self] _, user in
                DispatchQueue.main.async {
                    self?.currentUser = user
                    self?.isAuthenticated = user != nil
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
            await MainActor.run {
                self.currentUser = result.user
                self.isAuthenticated = true
                self.isLoading = false
            }
            let _ = print("is authenticated1: \(isAuthenticated)")
            return true
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            throw error
        }
    }
    
    func signUp(email: String, password: String) async throws -> Bool {
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
            let result = try await auth.createUser(withEmail: email, password: password)
            await MainActor.run {
                self.currentUser = result.user
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
    
    // MARK: - Face ID Integration
    
    func authenticateWithFaceID() async throws -> Bool {
        let context = LAContext()
        let reason = "Sign in to your R.E.P account"
        
        do {
            let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            
            if success {
                // If Face ID succeeds, try to sign in with saved credentials
                if let credentials = getSavedCredentials() {
                    return try await signIn(email: credentials.email, password: credentials.password)
                }
            }
            
            return success
        } catch {
            throw error
        }
    }
    
    func isFaceIDAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return context.biometryType == .faceID
        }
        return false
    }
    
    // MARK: - Keychain Operations
    
    func saveCredentials(email: String, password: String) {
        let credentials = "\(email):\(password)"
        
        guard let data = credentials.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Delete existing credentials first
        SecItemDelete(query as CFDictionary)
        
        // Add new credentials
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Firebase credentials saved to Keychain successfully")
        } else {
            print("Failed to save Firebase credentials to Keychain: \(status)")
        }
    }
    
    func getSavedCredentials() -> (email: String, password: String)? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let credentials = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        let components = credentials.split(separator: ":", maxSplits: 1)
        guard components.count == 2 else { return nil }
        
        return (String(components[0]), String(components[1]))
    }
    
    func deleteSavedCredentials() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Firebase credentials deleted from Keychain successfully")
        } else {
            print("Failed to delete Firebase credentials from Keychain: \(status)")
        }
    }
    
    // MARK: - User Profile Management
    
    func updateUserProfile(displayName: String? = nil, photoURL: URL? = nil) async throws {
        guard let user = currentUser else { return }
        
        let changeRequest = user.createProfileChangeRequest()
        if let displayName = displayName {
            changeRequest.displayName = displayName
        }
        if let photoURL = photoURL {
            changeRequest.photoURL = photoURL
        }
        
        try await changeRequest.commitChanges()
    }
    
    func deleteAccount() async throws {
        guard let user = currentUser else { return }
        
        try await user.delete()
        currentUser = nil
        isAuthenticated = false
        deleteSavedCredentials()
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
} 
