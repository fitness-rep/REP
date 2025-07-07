//
//  TargetWeightView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/6/25.
//

import SwiftUI

struct TargetWeightView: View {
    @State private var targetWeight: Double = 70
    @State private var weightUnit: WeightUnit = .kg
    @State private var navigateToNext = false
    @EnvironmentObject var registrationUser: RegistrationUser
    
    // This would be passed from the previous screen, but for now using a default
    let currentWeight: Double = 70
    
    private var weightDifference: Double {
        targetWeight - currentWeight
    }
    
    private var motivationalMessage: String {
        if weightDifference > 0 {
            return "10% lean muscle mass can be gained if you follow our diet and workouts consistently."
        } else if weightDifference < 0 {
            return "Healthy weight loss of \(abs(Int(weightDifference))) \(weightUnit == .kg ? "kg" : "lbs") is achievable with our personalized plan."
        } else {
            return "Maintaining your current weight is a great goal! We'll help you stay healthy and fit."
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Target Weight Section
                VStack(spacing: 24) {
                    Text("What's your target weight?")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.top, 40)
                    
                    // Unit toggle button
                    Button(action: { weightUnit = weightUnit == .kg ? .lbs : .kg }) {
                        HStack(spacing: 8) {
                            Image(systemName: weightUnit == .kg ? "scalemass" : "scalemass.fill")
                                .font(.system(size: 16, weight: .medium))
                            Text("Switch to \(weightUnit == .kg ? "Pounds" : "Kilograms")")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.orange)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.orange.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .padding(.bottom, 20)
                    
                    // Ruler picker for target weight
                    ScrollableRulerPicker(
                        value: $targetWeight,
                        minValue: weightUnit == .kg ? 1 : 2.2,
                        maxValue: weightUnit == .kg ? 300 : 660,
                        step: 1,
                        color: .orange,
                        unit: weightUnit == .kg ? "kg" : "lbs",
                        displayPrecision: 0,
                        width: UIScreen.main.bounds.width - 80
                    )
                    .frame(height: 140)
                    .padding(.horizontal, 20)
                    .onAppear {
                        // Ensure target weight is within valid range
                        if weightUnit == .kg {
                            targetWeight = min(max(targetWeight, 1), 300)
                        } else {
                            targetWeight = min(max(targetWeight, 2.2), 660)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                
                // Continue button
                Button(action: { 
                    navigateToNext = true
                    registrationUser.targetWeight = targetWeight
                    registrationUser.targetWeightUnit = weightUnit.rawValue
                    registrationUser.printProperties(context: "TargetWeightView -> TrainingFocusView")
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(16)
                        .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
                
                // Motivational message
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: weightDifference > 0 ? "arrow.up.circle.fill" : weightDifference < 0 ? "arrow.down.circle.fill" : "equal.circle.fill")
                            .foregroundColor(weightDifference > 0 ? .green : weightDifference < 0 ? .blue : .orange)
                            .font(.title2)
                        
                        Text(motivationalMessage)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
                
                NavigationLink(destination: TrainingFocusView().environmentObject(registrationUser), isActive: $navigateToNext) {
                    EmptyView()
                }
            }
        }
    }
}
