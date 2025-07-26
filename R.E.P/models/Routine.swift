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
    let goalId: String?
    let name: String
    let description: String
    let startDate: Date
    let createdAt: Date
    var isActive: Bool?
    let settings: RoutineSettings?
    let progress: RoutineProgress?
    let customizations: RoutineCustomizations?
    let dailySchedule: [DailyActivity]
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "documentId": documentId,
            "goalId": goalId as Any,
            "name": name,
            "description": description,
            "startDate": startDate,
            "createdAt": createdAt,
            "isActive": isActive as Any,
            "dailySchedule": dailySchedule.map { $0.toDictionary() },
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
              let name = data["name"] as? String,
              let description = data["description"] as? String,
              let startDate = data["startDate"] as? Date,
              let createdAt = data["createdAt"] as? Date,
              let isActive = data["isActive"] as? Bool else {
            return nil
        }
        let goalId = data["goalId"] as? String
        let settingsData = data["settings"] as? [String: Any]
        let settings = settingsData.flatMap { RoutineSettings.fromDictionary($0) }
        
        let progressData = data["progress"] as? [String: Any]
        let progress = progressData.flatMap { RoutineProgress.fromDictionary($0) }
        
        let customizationsData = data["customizations"] as? [String: Any]
        let customizations = customizationsData.flatMap { RoutineCustomizations.fromDictionary($0) }
        
        let dailyScheduleData = data["dailySchedule"] as? [[String: Any]] ?? []
        let dailySchedule = dailyScheduleData.compactMap { DailyActivity.fromDictionary($0) }
        
        return Routine(
            documentId: documentId,
            goalId: goalId,
            name: name,
            description: description,
            startDate: startDate,
            createdAt: createdAt,
            isActive: isActive,
            settings: settings,
            progress: progress,
            customizations: customizations,
            dailySchedule: dailySchedule
        )
    }
}

struct DailyActivity: Codable, Identifiable {
    var id: String { activityId }
    let activityId: String
    let name: String
    let startTime: String              // "06:00", "08:00", "10:00"
    let endTime: String                // "08:00", "10:00", "12:00"
    let activityType: DailyActivityType
    let referenceId: String?           // mealPlanId, exercisePlanId, or nil for generic
    let description: String?
    let isRequired: Bool
    let order: Int
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "activityId": activityId,
            "name": name,
            "startTime": startTime,
            "endTime": endTime,
            "activityType": activityType.rawValue,
            "isRequired": isRequired,
            "order": order
        ]
        
        if let referenceId = referenceId {
            dict["referenceId"] = referenceId
        }
        if let description = description {
            dict["description"] = description
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> DailyActivity? {
        guard let activityId = data["activityId"] as? String,
              let name = data["name"] as? String,
              let startTime = data["startTime"] as? String,
              let endTime = data["endTime"] as? String,
              let activityTypeString = data["activityType"] as? String,
              let activityType = DailyActivityType(rawValue: activityTypeString),
              let isRequired = data["isRequired"] as? Bool,
              let order = data["order"] as? Int else {
            return nil
        }
        
        let referenceId = data["referenceId"] as? String
        let description = data["description"] as? String
        
        return DailyActivity(
            activityId: activityId,
            name: name,
            startTime: startTime,
            endTime: endTime,
            activityType: activityType,
            referenceId: referenceId,
            description: description,
            isRequired: isRequired,
            order: order
        )
    }
}

enum DailyActivityType: String, Codable, CaseIterable {
    case meal = "meal"                 // References mealPlanId
    case exercise = "exercise"         // References exercisePlanId  
    case generic = "generic"           // Wake up, work, sleep, etc.
    case rest = "rest"                 // Rest periods
    case work = "work"                 // Work periods
    case sleep = "sleep"               // Sleep periods
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
