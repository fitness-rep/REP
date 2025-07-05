//
//  LogWorkoutView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/4/25.
//

import SwiftUI

struct LogWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var dailyProgress: DailyProgress
    @State private var workoutName = ""
    @State private var duration = ""
    @State private var selectedWorkoutType = WorkoutType.strength
    
    enum WorkoutType: String, CaseIterable {
        case strength = "Strength Training"
        case cardio = "Cardio"
        case yoga = "Yoga"
        case hiit = "HIIT"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Log Your Workout")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Track your fitness activities")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top)
                    
                    // Workout Type Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Workout Type")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(WorkoutType.allCases, id: \.self) { workoutType in
                                WorkoutTypeButton(
                                    title: workoutType.rawValue,
                                    isSelected: selectedWorkoutType == workoutType
                                ) {
                                    selectedWorkoutType = workoutType
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Workout Details
                    VStack(spacing: 20) {
                        // Workout Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Workout Name")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            TextField("e.g., Upper Body Strength", text: $workoutName)
                                .textFieldStyle(CustomTextFieldStyle(accentColor: .green))
                        }
                        
                        // Duration
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Duration (minutes)")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            TextField("Enter duration", text: $duration)
                                .textFieldStyle(CustomTextFieldStyle(accentColor: .green))
                                .keyboardType(.numberPad)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Current Progress Preview
                    VStack(spacing: 16) {
                        Text("Today's Progress")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 20) {
                            VStack(spacing: 4) {
                                Text("\(Int(dailyProgress.workoutMinutesCompleted))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                
                                Text("Completed")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            VStack(spacing: 4) {
                                Text("\(Int(dailyProgress.workoutMinutesTarget))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Target")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            VStack(spacing: 4) {
                                Text("\(Int(dailyProgress.workoutMinutesRemaining))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                                
                                Text("Remaining")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                    .padding(.horizontal)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: logWorkout) {
                            Text("Log Workout")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [.green, .green.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                )
                        }
                        .disabled(workoutName.isEmpty || duration.isEmpty)
                        
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func logWorkout() {
        guard let durationValue = Double(duration), durationValue > 0 else { return }
        
        dailyProgress.logWorkout(durationValue)
        dismiss()
    }
}

struct WorkoutTypeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.green : Color.white.opacity(0.1))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}



#Preview {
    LogWorkoutView(dailyProgress: DailyProgress(userData: RegistrationData()))
} 