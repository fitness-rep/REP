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
            VStack(spacing: 40) {
                Text("Select Your Gender")
                    .font(.title)
                    .fontWeight(.bold)

                HStack(spacing: 30) {
                    ForEach([Gender.male, Gender.female], id: \.self) { gender in
                                            Button {
                                                registrationData.gender = gender
                                                navigateToNameView = true
                                            } label: {
                                                GenderOptionCard(
                                                    gender: gender,
                                                    isSelected: registrationData.gender == gender
                                                )
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                }
                // Hidden NavigationLink activated by `navigateToNameView`
                NavigationLink(destination: NameView().environmentObject(registrationData), isActive: $navigateToNameView) {
                    EmptyView()
                }
            }
            .padding()
//            .navigationDestination(for: Gender.self) { _ in
//                NameView().environmentObject(registrationData)
//            }
        }
    }
}

