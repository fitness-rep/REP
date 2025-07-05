//
//  TodaysWorkoutPlanView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/4/25.
//

import SwiftUI

struct TodaysWorkoutPlanView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var dailyProgress: DailyProgress
    @State private var showingLogWorkout = false
    
    // Sample workout plan data - in a real app, this would come from a database
    private let todaysWorkouts = [
        WorkoutPlanItem(name: "Morning Cardio", duration: 30, type: "Cardio", intensity: "Moderate", isCompleted: false),
        WorkoutPlanItem(name: "Strength Training", duration: 45, type: "Strength", intensity: "High", isCompleted: false),
        WorkoutPlanItem(name: "Evening Stretch", duration: 15, type: "Flexibility", intensity: "Low", isCompleted: false)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Today's Workout Plan")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Your personalized fitness routine for today")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top)
                    
                    // Progress Summary
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Workout Time")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("\(Int(dailyProgress.workoutMinutesCompleted)) / \(Int(dailyProgress.workoutMinutesTarget)) min")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Progress")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("\(Int(dailyProgress.workoutProgress * 100))%")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        LinearGradient(
                                            colors: [.green, .green.opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * dailyProgress.workoutProgress, height: 8)
                                    .animation(.easeInOut(duration: 1.0), value: dailyProgress.workoutProgress)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                    .padding(.horizontal)
                    
                    // Workout List
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(todaysWorkouts, id: \.id) { workout in
                                WorkoutPlanCard(workout: workout) {
                                    // Mark workout as completed
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: { showingLogWorkout = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Text("Log Additional Workout")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
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
                        
                        Button("Close") {
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
        .sheet(isPresented: $showingLogWorkout) {
            LogWorkoutView(dailyProgress: dailyProgress)
        }
    }
}

struct WorkoutPlanCard: View {
    let workout: WorkoutPlanItem
    let onComplete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Workout icon
            ZStack {
                Circle()
                    .fill(workout.isCompleted ? Color.green.opacity(0.2) : Color.green.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: workout.isCompleted ? "checkmark.circle.fill" : "figure.strengthtraining.traditional")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(workout.isCompleted ? .green : .green)
            }
            
            // Workout details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(workout.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(workout.duration) min")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                HStack {
                    Text(workout.type)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Text(workout.intensity)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
            }
            
            // Complete button
            Button(action: onComplete) {
                Image(systemName: workout.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(workout.isCompleted ? .green : .white.opacity(0.6))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(workout.isCompleted ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1)
                )
        )
    }
}

struct WorkoutPlanItem {
    let id = UUID()
    let name: String
    let duration: Int
    let type: String
    let intensity: String
    var isCompleted: Bool
}

#Preview {
    TodaysWorkoutPlanView(dailyProgress: DailyProgress(userData: RegistrationData()))
} 