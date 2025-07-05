//
//  DailyProgress.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/4/25.
//

import Foundation
import SwiftUI

class DailyProgress: ObservableObject {
    @Published var caloriesConsumed: Double = 0.0
    @Published var caloriesTarget: Double = 2000.0
    @Published var workoutMinutesCompleted: Double = 0.0
    @Published var workoutMinutesTarget: Double = 60.0
    @Published var date: Date = Date()
    
    // Computed properties for progress calculations
    var caloriesProgress: Double {
        return min(caloriesConsumed / caloriesTarget, 1.0)
    }
    
    var workoutProgress: Double {
        return min(workoutMinutesCompleted / workoutMinutesTarget, 1.0)
    }
    
    var caloriesRemaining: Double {
        return max(caloriesTarget - caloriesConsumed, 0.0)
    }
    
    var workoutMinutesRemaining: Double {
        return max(workoutMinutesTarget - workoutMinutesCompleted, 0.0)
    }
    
    // Initialize with user data
    init(userData: RegistrationData) {
        calculateTargets(for: userData)
    }
    
    private func calculateTargets(for userData: RegistrationData) {
        // Calculate calorie target based on user data
        caloriesTarget = calculateCalorieTarget(
            age: userData.age,
            weight: userData.weight,
            height: userData.height,
            gender: userData.gender,
            fitnessGoal: userData.fitnessGoal
        )
        
        // Calculate workout target based on fitness goal
        workoutMinutesTarget = calculateWorkoutTarget(fitnessGoal: userData.fitnessGoal)
    }
    
    private func calculateCalorieTarget(age: Int, weight: Double, height: Double, gender: Gender, fitnessGoal: String) -> Double {
        // Basic BMR calculation using Mifflin-St Jeor Equation
        let bmr: Double
        if gender == .male {
            bmr = (10 * weight) + (6.25 * height) - (5 * Double(age)) + 5
        } else {
            bmr = (10 * weight) + (6.25 * height) - (5 * Double(age)) - 161
        }
        
        // Activity multiplier (assuming moderate activity)
        let activityMultiplier = 1.55
        
        // Base daily calories
        var dailyCalories = bmr * activityMultiplier
        
        // Adjust based on fitness goal
        switch fitnessGoal.lowercased() {
        case "lose weight", "weight loss":
            dailyCalories -= 500 // Calorie deficit
        case "gain weight", "muscle gain":
            dailyCalories += 300 // Calorie surplus
        case "maintain weight", "maintenance":
            // Keep as is
            break
        default:
            // Default to maintenance
            break
        }
        
        return round(dailyCalories)
    }
    
    private func calculateWorkoutTarget(fitnessGoal: String) -> Double {
        switch fitnessGoal.lowercased() {
        case "lose weight", "weight loss":
            return 75.0 // More cardio for weight loss
        case "gain weight", "muscle gain":
            return 60.0 // Strength training focus
        case "maintain weight", "maintenance":
            return 45.0 // Moderate activity
        default:
            return 60.0 // Default
        }
    }
    
    // Methods to update progress
    func logCalories(_ calories: Double) {
        caloriesConsumed += calories
        objectWillChange.send()
    }
    
    func logWorkout(_ minutes: Double) {
        workoutMinutesCompleted += minutes
        objectWillChange.send()
    }
    
    func resetDailyProgress() {
        caloriesConsumed = 0.0
        workoutMinutesCompleted = 0.0
        date = Date()
        objectWillChange.send()
    }
} 