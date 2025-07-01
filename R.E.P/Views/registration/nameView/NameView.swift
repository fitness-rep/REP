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
                Button("Continue") {
                    navigateToPrivacy = true
                }
                .buttonStyle(.borderedProminent)
                NavigationLink(destination: PrivacyFirstView().environmentObject(registrationData), isActive: $navigateToPrivacy) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
}
