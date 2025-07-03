//
//  HomeView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import SwiftUI
import AVKit

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSignIn = false
    @State private var isVideoLoaded = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Video
                BackgroundVideoView(isLoaded: $isVideoLoaded)
                
                // Gradient Overlay
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.7),
                        Color.black.opacity(0.4),
                        Color.black.opacity(0.6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Content
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        
                        // Action Buttons
                        VStack(spacing: 20) {
                            // Get Started Button
                            NavigationLink(destination: GenderSelectionView().environmentObject(RegistrationData())) {
                                HStack(spacing: 12) {
                                    Image(systemName: "figure.run")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    
                                    Text("Get Started with R.E.P")
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
                                .shadow(color: .purple.opacity(0.3), radius: 12, x: 0, y: 6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                            }
                            .buttonStyle(HomeButtonStyle())
                            
                            // Sign In Button
                            Button(action: { showSignIn = true }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "person.circle")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    
                                    Text("Already have an account? Sign In")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            }
                            .buttonStyle(HomeButtonStyle())
                            

                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                    }
                }
            }
        }
        .sheet(isPresented: $showSignIn) {
            SignInView()
        }
        .preferredColorScheme(.dark)
    }
}

// Background Video View
struct BackgroundVideoView: View {
    @Binding var isLoaded: Bool
    
    var body: some View {
        ZStack {
            // Animated fitness background
            FitnessBackgroundAnimation()
                .onAppear {
                    isLoaded = true
                }
        }
    }
}

// Custom fitness background animation
struct FitnessBackgroundAnimation: View {
    @State private var animationPhase = 0.0
    
    var body: some View {
        ZStack {
            // Base gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color(red: 0.1, green: 0.1, blue: 0.25),
                    Color(red: 0.08, green: 0.08, blue: 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated fitness elements
            ForEach(0..<6, id: \.self) { index in
                FitnessElement(index: index)
            }
            
            // Floating particles
            ForEach(0..<8, id: \.self) { index in
                FloatingParticle(index: index)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: false)) {
                animationPhase = 1.0
            }
        }
    }
}

// Individual fitness element
struct FitnessElement: View {
    let index: Int
    @State private var isAnimating = false
    
    var body: some View {
        Group {
            switch index % 4 {
            case 0:
                Image(systemName: "figure.run")
                    .font(.system(size: 40))
                    .foregroundColor(.blue.opacity(0.3))
            case 1:
                Image(systemName: "dumbbell")
                    .font(.system(size: 35))
                    .foregroundColor(.purple.opacity(0.3))
            case 2:
                Image(systemName: "heart.circle")
                    .font(.system(size: 45))
                    .foregroundColor(.pink.opacity(0.3))
            case 3:
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 38))
                    .foregroundColor(.green.opacity(0.3))
            default:
                Image(systemName: "figure.run")
                    .font(.system(size: 40))
                    .foregroundColor(.blue.opacity(0.3))
            }
        }
        .offset(
            x: CGFloat(cos(Double(index) * .pi / 3)) * 120,
            y: CGFloat(sin(Double(index) * .pi / 3)) * 120
        )
        .scaleEffect(isAnimating ? 1.1 : 0.9)
        .opacity(isAnimating ? 0.5 : 0.2)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 4.0)
                .repeatForever(autoreverses: true)
                .delay(Double(index) * 0.3)
            ) {
                isAnimating = true
            }
        }
    }
}

// Floating particle effect
struct FloatingParticle: View {
    let index: Int
    @State private var isFloating = false
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.3),
                        Color.purple.opacity(0.3)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: CGFloat(index % 3 + 4), height: CGFloat(index % 3 + 4))
            .offset(
                x: CGFloat(index * 50 - 200),
                y: CGFloat(index * 30 - 150)
            )
            .opacity(isFloating ? 0.6 : 0.2)
            .scaleEffect(isFloating ? 1.3 : 0.7)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 5.0)
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) * 0.2)
                ) {
                    isFloating = true
                }
            }
    }
}

// Custom Button Style for Home View
struct HomeButtonStyle: ButtonStyle {
    @State private var isPressed = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .onChange(of: configuration.isPressed) { pressed in
                isPressed = pressed
            }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
