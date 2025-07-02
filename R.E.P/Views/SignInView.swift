//
//  SignInView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import SwiftUI
import LocalAuthentication

struct SignInView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authManager = FirebaseAuthManager()
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showFaceIDSetup = false
    @State private var showKeychainPrompt = false
    @State private var rememberCredentials = false
    @State private var isSignUp = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text(isSignUp ? "Create Account" : "Welcome Back!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(isSignUp ? "Sign up for your R.E.P account" : "Sign in to your R.E.P account")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)
                
                // Face ID Button (if available and not sign up)
                if !isSignUp && authManager.isFaceIDAvailable() {
                    Button(action: signInWithFaceID) {
                        HStack {
                            Image(systemName: "faceid")
                                .font(.title2)
                            Text("Sign in with Face ID")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Text("or")
                        .foregroundColor(.secondary)
                        .padding(.vertical, 10)
                }
                
                // Email/Password Form
                VStack(spacing: 20) {
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter your email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        SecureField("Enter your password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Remember Credentials Option (only for sign in)
                    if !isSignUp {
                        Toggle("Save credentials securely", isOn: $rememberCredentials)
                            .font(.subheadline)
                            .padding(.vertical, 5)
                    }
                }
                .padding(.horizontal)
                
                // Sign In/Up Button
                Button(action: authenticateUser) {
                    HStack {
                        if authManager.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Text(isSignUp ? "Sign Up" : "Sign In")
                                .font(.headline)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .disabled(email.isEmpty || password.isEmpty || authManager.isLoading)
                .padding(.horizontal)
                
                // Forgot Password (only for sign in)
                if !isSignUp {
                    Button("Forgot Password?") {
                        resetPassword()
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
                
                // Toggle between Sign In and Sign Up
                Button(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up") {
                    isSignUp.toggle()
                }
                .font(.subheadline)
                .foregroundColor(.blue)
                
                Spacer()
            }
            .padding()
            .navigationTitle(isSignUp ? "Sign Up" : "Sign In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert(isSignUp ? "Sign Up" : "Sign In", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
            .sheet(isPresented: $showFaceIDSetup) {
                FaceIDSetupView(authManager: authManager)
            }
            .onAppear {
                checkSavedCredentials()
            }
            .onChange(of: authManager.errorMessage) { errorMessage in
                if let error = errorMessage {
                    alertMessage = error
                    showAlert = true
                }
            }
            .onChange(of: authManager.isAuthenticated) { isAuthenticated in
                if isAuthenticated {
                    dismiss()
                }
            }
        }
    }
    
    // MARK: - Methods
    
    private func signInWithFaceID() {
        Task {
            do {
                let success = try await authManager.authenticateWithFaceID()
                if !success {
                    await MainActor.run {
                        alertMessage = "Face ID authentication failed. Please try again or use email/password."
                        showAlert = true
                    }
                }
            } catch {
                await MainActor.run {
                    alertMessage = "Face ID authentication error: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
    
    private func authenticateUser() {
        Task {
            do {
                if isSignUp {
                    let success = try await authManager.signUp(email: email, password: password)
                    if success && rememberCredentials {
                        authManager.saveCredentials(email: email, password: password)
                    }
                } else {
                    let success = try await authManager.signIn(email: email, password: password)
                    if success && rememberCredentials {
                        authManager.saveCredentials(email: email, password: password)
                    }
                }
            } catch {
                await MainActor.run {
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
    
    private func resetPassword() {
        guard !email.isEmpty else {
            alertMessage = "Please enter your email address first."
            showAlert = true
            return
        }
        
        Task {
            do {
                try await authManager.resetPassword(email: email)
                await MainActor.run {
                    alertMessage = "Password reset email sent. Please check your inbox."
                    showAlert = true
                }
            } catch {
                await MainActor.run {
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
    
    private func checkSavedCredentials() {
        if let savedEmail = authManager.getSavedCredentials()?.email {
            email = savedEmail
        }
    }
}

#Preview {
    SignInView()
} 