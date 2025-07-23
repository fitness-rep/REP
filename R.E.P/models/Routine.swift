//
//  Routine.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//

import Foundation

struct Routine: Codable, Identifiable {
    var id: String { documentId }
    let documentId: String
    let userId: String
    let name: String
    let description: String
    let exercisePlanId: String
    let mealPlanId: String
    let goalStartDate: Date
    let createdAt: Date
    var goalId: String?
    var isActive: Bool?
    let currentDay: Int
    let settings: RoutineSettings?
    let progress: RoutineProgress?
    let customizations: RoutineCustomizations?
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "documentId": documentId,
            "userId": userId,
            "name": name,
            "description": description,
            "exercisePlanId": exercisePlanId,
            "mealPlanId": mealPlanId,
            "goalStartDate": goalStartDate,
            "createdAt": createdAt,
            "isActive": isActive as Any,
            "currentDay": currentDay,
            "schemaVersion": schemaVersion
        ]
        
        if let settings = settings {
            dict["settings"] = settings.toDictionary()
        }
        if let progress = progress {
            dict["progress"] = progress.toDictionary()
        }
        if let customizations = customizations {
            dict["customizations"] = customizations.toDictionary()
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> Routine? {
        guard let documentId = data["documentId"] as? String,
              let userId = data["userId"] as? String,
              let name = data["name"] as? String,
              let description = data["description"] as? String,
              let exercisePlanId = data["exercisePlanId"] as? String,
              let mealPlanId = data["mealPlanId"] as? String,
              let goalStartDate = data["goalStartDate"] as? Date,
              let createdAt = data["createdAt"] as? Date,
              let isActive = data["isActive"] as? Bool,
              let currentDay = data["currentDay"] as? Int else {
            return nil
        }
        
        let goalId = data["goalId"] as? String
        let settingsData = data["settings"] as? [String: Any]
        let settings = settingsData.flatMap { RoutineSettings.fromDictionary($0) }
        
        let progressData = data["progress"] as? [String: Any]
        let progress = progressData.flatMap { RoutineProgress.fromDictionary($0) }
        
        let customizationsData = data["customizations"] as? [String: Any]
        let customizations = customizationsData.flatMap { RoutineCustomizations.fromDictionary($0) }
        
        return Routine(
            documentId: documentId,
            userId: userId,
            name: name,
            description: description,
            exercisePlanId: exercisePlanId,
            mealPlanId: mealPlanId,
            goalStartDate: goalStartDate,
            createdAt: createdAt,
            goalId: goalId,
            isActive: isActive,
            currentDay: currentDay,
            settings: settings,
            progress: progress,
            customizations: customizations
        )
    }
}

struct RoutineSettings: Codable {
    let workoutDays: [String]
    let mealReminders: Bool
    let workoutReminders: Bool
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "workoutDays": workoutDays,
            "mealReminders": mealReminders,
            "workoutReminders": workoutReminders
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> RoutineSettings? {
        guard let workoutDays = data["workoutDays"] as? [String],
              let mealReminders = data["mealReminders"] as? Bool,
              let workoutReminders = data["workoutReminders"] as? Bool else {
            return nil
        }
        
        return RoutineSettings(
            workoutDays: workoutDays,
            mealReminders: mealReminders,
            workoutReminders: workoutReminders
        )
    }
}

struct RoutineProgress: Codable {
    let completedWorkouts: Int
    let completedMeals: Int
    let lastWorkoutDate: Date?
    let lastMealDate: Date?
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "completedWorkouts": completedWorkouts,
            "completedMeals": completedMeals
        ]
        
        if let lastWorkoutDate = lastWorkoutDate {
            dict["lastWorkoutDate"] = lastWorkoutDate
        }
        if let lastMealDate = lastMealDate {
            dict["lastMealDate"] = lastMealDate
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> RoutineProgress? {
        guard let completedWorkouts = data["completedWorkouts"] as? Int,
              let completedMeals = data["completedMeals"] as? Int else {
            return nil
        }
        
        let lastWorkoutDate = data["lastWorkoutDate"] as? Date
        let lastMealDate = data["lastMealDate"] as? Date
        
        return RoutineProgress(
            completedWorkouts: completedWorkouts,
            completedMeals: completedMeals,
            lastWorkoutDate: lastWorkoutDate,
            lastMealDate: lastMealDate
        )
    }
}

struct RoutineCustomizations: Codable {
    let modifiedExercises: [RoutineExerciseModification]?
    let modifiedMeals: [RoutineMealModification]?
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        if let modifiedExercises = modifiedExercises {
            dict["modifiedExercises"] = modifiedExercises.map { $0.toDictionary() }
        }
        if let modifiedMeals = modifiedMeals {
            dict["modifiedMeals"] = modifiedMeals.map { $0.toDictionary() }
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> RoutineCustomizations? {
        let modifiedExercisesData = data["modifiedExercises"] as? [[String: Any]]
        let modifiedExercises = modifiedExercisesData?.compactMap { RoutineExerciseModification.fromDictionary($0) }
        
        let modifiedMealsData = data["modifiedMeals"] as? [[String: Any]]
        let modifiedMeals = modifiedMealsData?.compactMap { RoutineMealModification.fromDictionary($0) }
        
        return RoutineCustomizations(
            modifiedExercises: modifiedExercises,
            modifiedMeals: modifiedMeals
        )
    }
}

struct RoutineExerciseModification: Codable {
    let exerciseName: String
    let modifiedBy: String
    let modifiedAt: Date
    let newProgression: [ExerciseProgression]
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "exerciseName": exerciseName,
            "modifiedBy": modifiedBy,
            "modifiedAt": modifiedAt,
            "newProgression": newProgression.map { $0.toDictionary() }
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> RoutineExerciseModification? {
        guard let exerciseName = data["exerciseName"] as? String,
              let modifiedBy = data["modifiedBy"] as? String,
              let modifiedAt = data["modifiedAt"] as? Date else {
            return nil
        }
        
        let newProgressionData = data["newProgression"] as? [[String: Any]] ?? []
        let newProgression = newProgressionData.compactMap { ExerciseProgression.fromDictionary($0) }
        
        return RoutineExerciseModification(
            exerciseName: exerciseName,
            modifiedBy: modifiedBy,
            modifiedAt: modifiedAt,
            newProgression: newProgression
        )
    }
}

struct RoutineMealModification: Codable {
    let mealId: String
    let modifiedBy: String
    let modifiedAt: Date
    let newProgression: [MealProgression]
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "mealId": mealId,
            "modifiedBy": modifiedBy,
            "modifiedAt": modifiedAt,
            "newProgression": newProgression.map { $0.toDictionary() }
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> RoutineMealModification? {
        guard let mealId = data["mealId"] as? String,
              let modifiedBy = data["modifiedBy"] as? String,
              let modifiedAt = data["modifiedAt"] as? Date else {
            return nil
        }
        
        let newProgressionData = data["newProgression"] as? [[String: Any]] ?? []
        let newProgression = newProgressionData.compactMap { MealProgression.fromDictionary($0) }
        
        return RoutineMealModification(
            mealId: mealId,
            modifiedBy: modifiedBy,
            modifiedAt: modifiedAt,
            newProgression: newProgression
        )
    }
}
