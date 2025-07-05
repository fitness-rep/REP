//
//  CustomTextFieldStyle.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/4/25.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    let accentColor: Color
    
    init(accentColor: Color = .blue) {
        self.accentColor = accentColor
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.1))
            )
            .foregroundColor(.white)
            .accentColor(accentColor)
    }
} 