//
//  AuthenticationManager.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import Foundation
import LocalAuthentication
import Security

class AuthenticationManager: ObservableObject {
    @Published var isFaceIDAvailable = false
    @Published var isFaceIDEnabled = false
    
    private let keychainService = "com.rep.app"
    private let faceIDEnabledKey = "faceIDEnabled"
    private let userDefaults = UserDefaults.standard
    
    init() {
        checkFaceIDAvailability()
        loadFaceIDPreference()
    }
    
    // MARK: - Face ID Methods
    
    private func checkFaceIDAvailability() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            isFaceIDAvailable = context.biometryType == .faceID
        } else {
            isFaceIDAvailable = false
        }
    }
    
    func authenticateWithFaceID() async throws -> Bool {
        let context = LAContext()
        let reason = "Sign in to your R.E.P account"
        
        do {
            let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            return success
        } catch {
            throw error
        }
    }
    
    func enableFaceID() {
        isFaceIDEnabled = true
        userDefaults.set(true, forKey: faceIDEnabledKey)
    }
    
    func disableFaceID() {
        isFaceIDEnabled = false
        userDefaults.set(false, forKey: faceIDEnabledKey)
    }
    
    private func loadFaceIDPreference() {
        isFaceIDEnabled = userDefaults.bool(forKey: faceIDEnabledKey)
    }
    
    // MARK: - Keychain Methods
    
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
            print("Credentials saved to Keychain successfully")
        } else {
            print("Failed to save credentials to Keychain: \(status)")
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
    
    func getSavedEmail() -> String? {
        return getSavedCredentials()?.email
    }
    
    func getSavedPassword() -> String? {
        return getSavedCredentials()?.password
    }
    
    func deleteSavedCredentials() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Credentials deleted from Keychain successfully")
        } else {
            print("Failed to delete credentials from Keychain: \(status)")
        }
    }
    
    // MARK: - Authentication Methods
    
    func authenticateUser(email: String, password: String) async -> Bool {
        // In a real app, this would make an API call to your backend
        // For demo purposes, we'll simulate authentication
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // For demo: accept any non-empty credentials
        return !email.isEmpty && !password.isEmpty
    }
    
    func signOut() {
        // Clear any session data
        // In a real app, you might want to keep credentials in Keychain
        // but clear session tokens
    }
} 