//
//  RegistrationView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import SwiftUI

struct GenderSelectionView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @State private var selectedGender: Gender? = nil
    @State private var navigateToNameView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    Spacer()
                    VStack(spacing: 28) {
                        VStack(spacing: 8) {
                            Text("WHAT'S YOUR GENDER?")
                                .font(.system(size: 26, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            Text("This will help us personalize your plan to your physique")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 16)
                        HStack(spacing: 28) {
                            ForEach([Gender.male, Gender.female], id: \ .self) { gender in
                                Button {
                                    withAnimation(.spring()) {
                                        selectedGender = gender
                                        registrationData.gender = gender
                                        navigateToNameView = true
                                    }
                                } label: {
                                    GenderOptionCard(
                                        gender: gender,
                                        isSelected: selectedGender == gender
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                    }
                    Spacer()
                    // NavigationLink
                    NavigationLink(destination: NameView().environmentObject(registrationData), isActive: $navigateToNameView) {
                        EmptyView()
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

