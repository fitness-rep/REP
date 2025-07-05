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
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Log Your Workout")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Track your fitness activities")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Workout Type Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Workout Type")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
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
                        
                        TextField("e.g., Upper Body Strength", text: $workoutName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Duration
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Duration (minutes)")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        TextField("Enter duration", text: $duration)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 4) {
                            Text("\(Int(dailyProgress.workoutMinutesCompleted))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            
                            Text("Completed")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Text("\(Int(dailyProgress.workoutMinutesTarget))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Target")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Text("\(Int(dailyProgress.workoutMinutesRemaining))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            
                            Text("Remaining")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
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
                                    .fill(Color.green)
                            )
                    }
                    .disabled(workoutName.isEmpty || duration.isEmpty)
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.bottom)
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
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.green : Color(.systemGray5))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    LogWorkoutView(dailyProgress: DailyProgress(userData: RegistrationData()))
} 