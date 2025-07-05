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
                // Background circle with gradient
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [color.opacity(0.1), color.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 8
                    )
                    .frame(width: size, height: size)
                
                // Progress circle with gradient
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .round
                        )
                    )
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: progress)
                
                // Inner glow effect
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: size - 16, height: size - 16)
                    .blur(radius: 8)
                
                // Center content
                VStack(spacing: 2) {
                    Text(value)
                        .font(.system(size: size * 0.25, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    
                    Text(subtitle)
                        .font(.system(size: size * 0.12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                }
            }
            
            Text(title)
                .font(.system(size: size * 0.15, weight: .semibold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
        }
    }
}

// Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
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
            
            CircularProgressView(
                progress: 0.60,
                title: "Goal Progress",
                value: "60%",
                subtitle: "Complete",
                color: .purple,
                size: 160
            )
        }
        .padding()
    }
} 