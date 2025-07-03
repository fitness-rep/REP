//
//  NameView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//
import SwiftUI

struct NameView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @State private var navigateToPrivacy = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Spacer()
                    // Headline
                    VStack(spacing: 12) {
                        Text("What should I call you?")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 36)
                    // Floating Label TextField
                    ZStack(alignment: .leading) {
                        if registrationData.name.isEmpty && !isFocused {
                            Text("Your name")
                                .foregroundColor(.gray)
                                .font(.system(size: 18, weight: .medium))
                                .padding(.leading, 22)
                        }
                        TextField("", text: $registrationData.name)
                            .focused($isFocused)
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.horizontal, 22)
                            .padding(.vertical, 18)
                            .background(
                                Capsule()
                                    .fill(Color(.systemGray6).opacity(0.12))
                                    .overlay(
                                        Capsule()
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: isFocused ? [Color.blue, Color.purple] : [Color.gray.opacity(0.4), Color.gray.opacity(0.2)]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: isFocused ? 3 : 1.5
                                            )
                                            .shadow(color: isFocused ? Color.blue.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                                    )
                            )
                            .padding(.horizontal, 8)
                            .animation(.easeInOut(duration: 0.25), value: isFocused)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                    Spacer()
                    // Next Button
                    Button(action: { navigateToPrivacy = true }) {
                        Text("Next")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(32)
                            .shadow(color: .purple.opacity(0.3), radius: 12, x: 0, y: 6)
                            .opacity(registrationData.name.isEmpty ? 0.5 : 1.0)
                    }
                    .disabled(registrationData.name.isEmpty)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 48)
                    NavigationLink(destination: PrivacyFirstView().environmentObject(registrationData), isActive: $navigateToPrivacy) {
                        EmptyView()
                    }
                }
            }
        }
    }
}
