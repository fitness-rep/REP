//
//  FaceIDSetupView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import SwiftUI
import LocalAuthentication

struct FaceIDSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authManager: FirebaseAuthManager
    @State private var isSettingUp = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 15) {
                    Image(systemName: "faceid")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("Enable Face ID")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Sign in faster and more securely with Face ID")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 50)
                
                // Benefits
                VStack(alignment: .leading, spacing: 15) {
                    Text("Benefits:")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    BenefitRow(icon: "bolt.fill", text: "Faster sign-in experience")
                    BenefitRow(icon: "lock.shield.fill", text: "Enhanced security")
                    BenefitRow(icon: "hand.raised.fill", text: "No need to remember passwords")
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 15) {
                    Button(action: enableFaceID) {
                        HStack(spacing: 12) {
                            if isSettingUp {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "faceid")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            Text(isSettingUp ? "Setting up..." : "Enable Face ID")
                                .font(.headline)
                                .fontWeight(.semibold)
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
                    .disabled(isSettingUp)
                    .buttonStyle(HomeButtonStyle())
                    .padding(.horizontal)
                    
                    Button("Skip for now") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.bottom, 30)
            }
            .padding()
            .navigationTitle("Face ID Setup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") {
                        dismiss()
                    }
                }
            }
            .alert("Face ID Setup", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func enableFaceID() {
        isSettingUp = true
        
        Task {
            do {
                let success = try await authManager.authenticateWithFaceID()
                
                await MainActor.run {
                    isSettingUp = false
                    
                    if success {
                        alertMessage = "Face ID has been enabled successfully! You can now use Face ID to sign in."
                        showAlert = true
                        
                        // Dismiss after a short delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            dismiss()
                        }
                    } else {
                        alertMessage = "Face ID authentication failed. Please try again."
                        showAlert = true
                    }
                }
            } catch {
                await MainActor.run {
                    isSettingUp = false
                    alertMessage = "Face ID setup failed: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

#Preview {
    FaceIDSetupView(authManager: FirebaseAuthManager())
} 