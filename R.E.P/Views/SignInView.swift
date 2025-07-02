//
//  SignInView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import SwiftUI
import LocalAuthentication

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var rememberCredentials = false
    @State private var isSignUp = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                    HStack(spacing: 12) {
                        if authViewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: isSignUp ? "person.badge.plus" : "person.circle")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text(isSignUp ? "Sign Up" : "Sign In")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
                .buttonStyle(HomeButtonStyle())
                .padding(.horizontal)
                
                // Forgot Password (only for sign in)
                if !isSignUp {
                    Button("Forgot Password?") {
                        alertMessage = "Password reset is not implemented in this demo."
                        showAlert = true
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
            .alert(isSignUp ? "Sign Up" : "Sign In", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func authenticateUser() {
        Task {
            do {
                if isSignUp {
                    try await authViewModel.signUp(email: email, password: password)
                } else {
                    try await authViewModel.signIn(email: email, password: password)
                    let _ = print("is authenticated2: \(authViewModel.isAuthenticated)")
                }
            } catch {
                await MainActor.run {
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}

//#Preview {
//    SignInView()
//        .environmentObject(AuthViewModel())
//} 
