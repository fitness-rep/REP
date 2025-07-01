//
//  NameView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//
import SwiftUI

struct NameView: View {
    @EnvironmentObject var registrationData: RegistrationData
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("What should we call you")
                    .font(.title)
            }
            .padding()
        }
    }
}
