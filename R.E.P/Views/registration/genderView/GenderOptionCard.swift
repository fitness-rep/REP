//
//  GenderOptionCard.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//
import SwiftUI

struct GenderOptionCard: View {
    let gender: Gender
    let isSelected: Bool

    var body: some View {
        VStack {
            Image(gender == .male ? "male_avatar" : "female_avatar")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
                .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                .cornerRadius(12)

            Text(gender == .male ? "Male" : "Female")
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .blue : .primary)
        }
    }
}

