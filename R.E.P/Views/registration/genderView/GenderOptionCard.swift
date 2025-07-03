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
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(.systemGray6).opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                )
                .shadow(color: isSelected ? Color.blue.opacity(0.18) : Color.black.opacity(0.08), radius: isSelected ? 12 : 6, x: 0, y: 4)
            
            Image(gender == .male ? "male_avatar" : "female_avatar")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 220)
                .padding(.vertical, 16)
        }
        .frame(width: 180, height: 280)
        .padding(4)
    }
}

