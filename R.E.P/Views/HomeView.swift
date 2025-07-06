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
                    .ignoresSafeArea()
                
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
                .ignoresSafeArea()
                
                // Content
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        
                        // Action Buttons
                        VStack(spacing: 20) {
                            // Get Started Button
                            NavigationLink(destination: GenderSelectionView().environmentObject(RegistrationUser())) {
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
        GeometryReader { geometry in
            ZStack {
                // Animated fitness background
                FitnessBackgroundAnimation()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .onAppear {
                        isLoaded = true
                    }
            }
        }
        .ignoresSafeArea()
    }
}

// Premium fitness background animation
struct FitnessBackgroundAnimation: View {
    @State private var animationPhase = 0.0
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0.0
    
    var body: some View {
        ZStack {
            // Dynamic gradient background with movement
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.02, green: 0.02, blue: 0.08),
                    Color(red: 0.08, green: 0.05, blue: 0.15),
                    Color(red: 0.12, green: 0.08, blue: 0.25),
                    Color(red: 0.06, green: 0.04, blue: 0.12)
                ]),
                startPoint: UnitPoint(x: animationPhase, y: 0),
                endPoint: UnitPoint(x: 1 - animationPhase, y: 1)
            )
            
            // Animated geometric shapes
            ForEach(0..<12, id: \.self) { index in
                GeometricShape(index: index)
            }
            
            // Energy waves
            ForEach(0..<3, id: \.self) { index in
                EnergyWave(index: index, pulseScale: pulseScale)
            }
            
            // Floating fitness icons with glow
            ForEach(0..<8, id: \.self) { index in
                GlowingFitnessIcon(index: index, rotationAngle: rotationAngle)
            }
            
            // Particle system
            ForEach(0..<15, id: \.self) { index in
                AnimatedParticle(index: index)
            }
            
            // Light rays effect
            LightRaysEffect()
        }
        .onAppear {
            // Start continuous animations
            withAnimation(.easeInOut(duration: 12.0).repeatForever(autoreverses: false)) {
                animationPhase = 1.0
            }
            
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                pulseScale = 1.2
            }
            
            withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
}

// Geometric shapes with dynamic movement
struct GeometricShape: View {
    let index: Int
    @State private var isAnimating = false
    @State private var rotation: Double = 0
    
    var body: some View {
        Group {
            switch index % 4 {
            case 0:
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.1),
                                Color.purple.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
            case 1:
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.1),
                                Color.pink.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
            case 2:
                Triangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.orange.opacity(0.1),
                                Color.red.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
            case 3:
                Diamond()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(0.1),
                                Color.blue.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 45, height: 45)
            default:
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 55, height: 55)
            }
        }
        .offset(
            x: CGFloat(cos(Double(index) * .pi / 6)) * 150,
            y: CGFloat(sin(Double(index) * .pi / 6)) * 150
        )
        .scaleEffect(isAnimating ? 1.2 : 0.8)
        .rotationEffect(.degrees(rotation))
        .opacity(isAnimating ? 0.4 : 0.1)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 6.0)
                .repeatForever(autoreverses: true)
                .delay(Double(index) * 0.2)
            ) {
                isAnimating = true
            }
            
            withAnimation(
                .linear(duration: 15.0)
                .repeatForever(autoreverses: false)
                .delay(Double(index) * 0.3)
            ) {
                rotation = 360
            }
        }
    }
}

// Energy wave effect
struct EnergyWave: View {
    let index: Int
    let pulseScale: CGFloat
    @State private var waveOffset: CGFloat = 0
    
    var body: some View {
        Circle()
            .stroke(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.3),
                        Color.purple.opacity(0.2),
                        Color.clear
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 2
            )
            .frame(width: 200 + CGFloat(index * 100), height: 200 + CGFloat(index * 100))
            .scaleEffect(pulseScale)
            .offset(x: waveOffset, y: 0)
            .opacity(0.3 - Double(index) * 0.1)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 4.0)
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) * 0.5)
                ) {
                    waveOffset = 50
                }
            }
    }
}

// Glowing fitness icons
struct GlowingFitnessIcon: View {
    let index: Int
    let rotationAngle: Double
    @State private var isGlowing = false
    
    var body: some View {
        ZStack {
            // Glow effect
            Group {
                switch index % 5 {
                case 0:
                    Image(systemName: "figure.run")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.blue)
                case 1:
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.purple)
                case 2:
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.pink)
                case 3:
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.green)
                case 4:
                    Image(systemName: "flame.fill")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.orange)
                default:
                    Image(systemName: "figure.run")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.blue)
                }
            }
            .shadow(color: .blue.opacity(isGlowing ? 0.8 : 0.3), radius: isGlowing ? 15 : 5)
            .scaleEffect(isGlowing ? 1.1 : 1.0)
        }
        .offset(
            x: CGFloat(cos(Double(index) * .pi / 4)) * 180,
            y: CGFloat(sin(Double(index) * .pi / 4)) * 180
        )
        .rotationEffect(.degrees(rotationAngle))
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
                .delay(Double(index) * 0.3)
            ) {
                isGlowing = true
            }
        }
    }
}

// Advanced particle system
struct AnimatedParticle: View {
    let index: Int
    @State private var isMoving = false
    @State private var opacity: Double = 0.3
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.6),
                        Color.purple.opacity(0.4),
                        Color.pink.opacity(0.3)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: CGFloat(index % 4 + 3), height: CGFloat(index % 4 + 3))
            .offset(
                x: isMoving ? CGFloat(index * 30 - 150) : CGFloat(index * 20 - 100),
                y: isMoving ? CGFloat(index * 20 - 100) : CGFloat(index * 30 - 150)
            )
            .opacity(opacity)
            .scaleEffect(isMoving ? 1.5 : 0.8)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 8.0)
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) * 0.2)
                ) {
                    isMoving = true
                    opacity = 0.8
                }
            }
    }
}

// Light rays effect
struct LightRaysEffect: View {
    @State private var rayRotation: Double = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.1),
                                Color.clear
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 2, height: 300)
                    .rotationEffect(.degrees(Double(index) * 45 + rayRotation))
                    .offset(y: -100)
            }
        }
        .onAppear {
            withAnimation(
                .linear(duration: 30.0)
                .repeatForever(autoreverses: false)
            ) {
                rayRotation = 360
            }
        }
    }
}

// Custom shapes
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
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
        .environmentObject(RegistrationUser())
}
