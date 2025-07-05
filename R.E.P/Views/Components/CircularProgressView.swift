//
//  CircularProgressView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/4/25.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let size: CGFloat
    
    init(progress: Double, title: String, value: String, subtitle: String, color: Color, size: CGFloat = 120) {
        self.progress = progress
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.color = color
        self.size = size
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Background circle
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 8)
                    .frame(width: size, height: size)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        color,
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .round
                        )
                    )
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: progress)
                
                // Center content
                VStack(spacing: 2) {
                    Text(value)
                        .font(.system(size: size * 0.25, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: size * 0.12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            
            Text(title)
                .font(.system(size: size * 0.15, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
}

// Preview
#Preview {
    VStack(spacing: 20) {
        CircularProgressView(
            progress: 0.75,
            title: "Calories",
            value: "1,500",
            subtitle: "of 2,000",
            color: .blue
        )
        
        CircularProgressView(
            progress: 0.45,
            title: "Workout",
            value: "27",
            subtitle: "of 60 min",
            color: .green
        )
    }
    .padding()
} 