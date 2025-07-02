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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("What should we call you")
                    .font(.title)
                TextField("Enter your name", text: $registrationData.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action: {
                    navigateToPrivacy = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.right.circle")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Continue")
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
                .buttonStyle(HomeButtonStyle())
                .padding(.horizontal)
                NavigationLink(destination: PrivacyFirstView().environmentObject(registrationData), isActive: $navigateToPrivacy) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
}
