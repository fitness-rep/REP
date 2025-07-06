//
//  DailyProgress.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/4/25.
//

import Foundation

struct DailyProgress: Codable, Identifiable {
    var id: String { documentId }
    let documentId: String
    let userId: String
    let date: Date
    let caloriesConsumed: Double
    let caloriesTarget: Double
    let workoutMinutesCompleted: Double
    let workoutMinutesTarget: Double
    
    // Basic versioning for future extensibility
    var schemaVersion: Int = 1
    
    // Static date formatter for Firestore queries
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
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
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "documentId": documentId,
            "userId": userId,
            "date": Self.dateFormatter.string(from: date),
            "caloriesConsumed": caloriesConsumed,
            "caloriesTarget": caloriesTarget,
            "workoutMinutesCompleted": workoutMinutesCompleted,
            "workoutMinutesTarget": workoutMinutesTarget,
            "schemaVersion": schemaVersion
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> DailyProgress? {
        guard let documentId = data["documentId"] as? String,
              let userId = data["userId"] as? String,
              let dateString = data["date"] as? String,
              let date = dateFormatter.date(from: dateString),
              let caloriesConsumed = data["caloriesConsumed"] as? Double,
              let caloriesTarget = data["caloriesTarget"] as? Double,
              let workoutMinutesCompleted = data["workoutMinutesCompleted"] as? Double,
              let workoutMinutesTarget = data["workoutMinutesTarget"] as? Double else {
            return nil
        }
        
        return DailyProgress(
            documentId: documentId,
            userId: userId,
            date: date,
            caloriesConsumed: caloriesConsumed,
            caloriesTarget: caloriesTarget,
            workoutMinutesCompleted: workoutMinutesCompleted,
            workoutMinutesTarget: workoutMinutesTarget
        )
    }
    
    // Initialize with user data
    init(userId: String, date: Date, userData: RegistrationUser) {
        self.documentId = "\(userId)_\(Self.dateFormatter.string(from: date))"
        self.userId = userId
        self.date = date
        
        // Calculate targets based on user data
        self.caloriesTarget = Self.calculateCalorieTarget(
            age: userData.age,
            weight: userData.weight,
            height: userData.height,
            gender: userData.gender,
            fitnessGoal: userData.fitnessGoal
        )
        
        self.workoutMinutesTarget = Self.calculateWorkoutTarget(fitnessGoal: userData.fitnessGoal)
        
        // Initialize with zero progress
        self.caloriesConsumed = 0.0
        self.workoutMinutesCompleted = 0.0
    }
    
    // Initialize with existing data
    init(documentId: String, userId: String, date: Date, caloriesConsumed: Double, caloriesTarget: Double, workoutMinutesCompleted: Double, workoutMinutesTarget: Double) {
        self.documentId = documentId
        self.userId = userId
        self.date = date
        self.caloriesConsumed = caloriesConsumed
        self.caloriesTarget = caloriesTarget
        self.workoutMinutesCompleted = workoutMinutesCompleted
        self.workoutMinutesTarget = workoutMinutesTarget
    }
    
    // Helper methods for creating updated instances
    func withUpdatedCalories(_ newCalories: Double) -> DailyProgress {
        return DailyProgress(
            documentId: documentId,
            userId: userId,
            date: date,
            caloriesConsumed: newCalories,
            caloriesTarget: caloriesTarget,
            workoutMinutesCompleted: workoutMinutesCompleted,
            workoutMinutesTarget: workoutMinutesTarget
        )
    }
    
    func withUpdatedWorkoutMinutes(_ newMinutes: Double) -> DailyProgress {
        return DailyProgress(
            documentId: documentId,
            userId: userId,
            date: date,
            caloriesConsumed: caloriesConsumed,
            caloriesTarget: caloriesTarget,
            workoutMinutesCompleted: newMinutes,
            workoutMinutesTarget: workoutMinutesTarget
        )
    }
    
    func withAddedCalories(_ additionalCalories: Double) -> DailyProgress {
        return withUpdatedCalories(caloriesConsumed + additionalCalories)
    }
    
    func withAddedWorkoutMinutes(_ additionalMinutes: Double) -> DailyProgress {
        return withUpdatedWorkoutMinutes(workoutMinutesCompleted + additionalMinutes)
    }
    
    // Static helper methods
    private static func calculateCalorieTarget(age: Int, weight: Double, height: Double, gender: String, fitnessGoal: String) -> Double {
        // Basic BMR calculation using Mifflin-St Jeor Equation
        let bmr: Double
        if gender == "male" {
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
    
    private static func calculateWorkoutTarget(fitnessGoal: String) -> Double {
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
} 