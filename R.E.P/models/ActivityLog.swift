//
//  ActivityLog.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//

import Foundation
import FirebaseFirestore

struct ActivityLog: Codable, Identifiable {
    var id: String { documentId }
    let documentId: String
    let userId: String
    let activityType: ActivityType
    let timestamp: Date
    let duration: TimeInterval?
    
    // Basic versioning for future extensibility
    var schemaVersion: Int = 1
    
    // Activity-specific data
    let workoutLog: WorkoutLog?
    let mealLog: MealLog?
    let customActivityLog: CustomActivityLog?
    let deviceDataLog: DeviceDataLog?
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "documentId": documentId,
            "userId": userId,
            "activityType": activityType.rawValue,
            "timestamp": Timestamp(date: timestamp),
            "schemaVersion": schemaVersion
        ]
        
        if let duration = duration {
            dict["duration"] = duration
        }
        if let workoutLog = workoutLog {
            dict["workoutLog"] = workoutLog.toDictionary()
        }
        if let mealLog = mealLog {
            dict["mealLog"] = mealLog.toDictionary()
        }
        if let customActivityLog = customActivityLog {
            dict["customActivityLog"] = customActivityLog.toDictionary()
        }
        if let deviceDataLog = deviceDataLog {
            dict["deviceDataLog"] = deviceDataLog.toDictionary()
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> ActivityLog? {
        guard let documentId = data["documentId"] as? String,
              let userId = data["userId"] as? String,
              let activityTypeString = data["activityType"] as? String,
              let activityType = ActivityType(rawValue: activityTypeString) else {
            return nil
        }
        
        // Handle timestamp that might come from Firestore as Timestamp
        let timestamp: Date
        if let firestoreTimestamp = data["timestamp"] as? Timestamp {
            timestamp = firestoreTimestamp.dateValue()
        } else if let date = data["timestamp"] as? Date {
            timestamp = date
        } else {
            // Default to current date if not available
            timestamp = Date()
        }
        
        let duration = data["duration"] as? TimeInterval
        
        let workoutLogData = data["workoutLog"] as? [String: Any]
        let workoutLog = workoutLogData.flatMap { WorkoutLog.fromDictionary($0) }
        
        let mealLogData = data["mealLog"] as? [String: Any]
        let mealLog = mealLogData.flatMap { MealLog.fromDictionary($0) }
        
        let customActivityLogData = data["customActivityLog"] as? [String: Any]
        let customActivityLog = customActivityLogData.flatMap { CustomActivityLog.fromDictionary($0) }
        
        let deviceDataLogData = data["deviceDataLog"] as? [String: Any]
        let deviceDataLog = deviceDataLogData.flatMap { DeviceDataLog.fromDictionary($0) }
        
        return ActivityLog(
            documentId: documentId,
            userId: userId,
            activityType: activityType,
            timestamp: timestamp,
            duration: duration,
            workoutLog: workoutLog,
            mealLog: mealLog,
            customActivityLog: customActivityLog,
            deviceDataLog: deviceDataLog
        )
    }
}

enum ActivityType: String, Codable, CaseIterable {
    case workout = "workout"
    case meal = "meal"
    case custom = "custom"
    case deviceData = "device_data"
    case sleep = "sleep"
    case hydration = "hydration"
    case medication = "medication"
    case mood = "mood"
    case weight = "weight"
    case bodyComposition = "body_composition"
    case healthMetric = "health_metric"
    case goal = "goal"
    case achievement = "achievement"
}

struct WorkoutLog: Codable {
    let routineId: String?
    let exercisePlanId: String?
    let exercises: [WorkoutExercise]
    let totalCalories: Double?
    let averageHeartRate: Double?
    let maxHeartRate: Double?
    let totalDistance: Double?
    let totalSteps: Int?
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "exercises": exercises.map { $0.toDictionary() },
            "schemaVersion": schemaVersion
        ]
        
        if let routineId = routineId {
            dict["routineId"] = routineId
        }
        if let exercisePlanId = exercisePlanId {
            dict["exercisePlanId"] = exercisePlanId
        }
        if let totalCalories = totalCalories {
            dict["totalCalories"] = totalCalories
        }
        if let averageHeartRate = averageHeartRate {
            dict["averageHeartRate"] = averageHeartRate
        }
        if let maxHeartRate = maxHeartRate {
            dict["maxHeartRate"] = maxHeartRate
        }
        if let totalDistance = totalDistance {
            dict["totalDistance"] = totalDistance
        }
        if let totalSteps = totalSteps {
            dict["totalSteps"] = totalSteps
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> WorkoutLog? {
        let routineId = data["routineId"] as? String
        let exercisePlanId = data["exercisePlanId"] as? String
        let exercisesData = data["exercises"] as? [[String: Any]] ?? []
        let exercises = exercisesData.compactMap { WorkoutExercise.fromDictionary($0) }
        let totalCalories = data["totalCalories"] as? Double
        let averageHeartRate = data["averageHeartRate"] as? Double
        let maxHeartRate = data["maxHeartRate"] as? Double
        let totalDistance = data["totalDistance"] as? Double
        let totalSteps = data["totalSteps"] as? Int
        
        return WorkoutLog(
            routineId: routineId,
            exercisePlanId: exercisePlanId,
            exercises: exercises,
            totalCalories: totalCalories,
            averageHeartRate: averageHeartRate,
            maxHeartRate: maxHeartRate,
            totalDistance: totalDistance,
            totalSteps: totalSteps
        )
    }
}

struct WorkoutExercise: Codable, Identifiable {
    var id: String { exerciseId }
    let exerciseId: String
    let name: String
    let type: ExerciseType
    let sets: [WorkoutSet]
    let notes: String?
    let restBetweenSets: TimeInterval?
    let totalTime: TimeInterval?
    let calories: Double?
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "exerciseId": exerciseId,
            "name": name,
            "type": type.rawValue,
            "sets": sets.map { $0.toDictionary() }
        ]
        
        if let notes = notes {
            dict["notes"] = notes
        }
        if let restBetweenSets = restBetweenSets {
            dict["restBetweenSets"] = restBetweenSets
        }
        if let totalTime = totalTime {
            dict["totalTime"] = totalTime
        }
        if let calories = calories {
            dict["calories"] = calories
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> WorkoutExercise? {
        guard let exerciseId = data["exerciseId"] as? String,
              let name = data["name"] as? String,
              let typeString = data["type"] as? String,
              let type = ExerciseType(rawValue: typeString) else {
            return nil
        }
        
        let setsData = data["sets"] as? [[String: Any]] ?? []
        let sets = setsData.compactMap { WorkoutSet.fromDictionary($0) }
        let notes = data["notes"] as? String
        let restBetweenSets = data["restBetweenSets"] as? TimeInterval
        let totalTime = data["totalTime"] as? TimeInterval
        let calories = data["calories"] as? Double
        
        return WorkoutExercise(
            exerciseId: exerciseId,
            name: name,
            type: type,
            sets: sets,
            notes: notes,
            restBetweenSets: restBetweenSets,
            totalTime: totalTime,
            calories: calories
        )
    }
}

struct WorkoutSet: Codable, Identifiable {
    var id: String { "\(setNumber)" }
    let setNumber: Int
    let reps: Int?
    let weight: Double?
    let duration: TimeInterval?
    let distance: Double?
    let speed: Double?
    let resistance: Int?
    let rpm: Int?
    let calories: Double?
    let heartRate: Int?
    let notes: String?
    let isCompleted: Bool = true
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "setNumber": setNumber,
            "isCompleted": isCompleted
        ]
        
        if let reps = reps {
            dict["reps"] = reps
        }
        if let weight = weight {
            dict["weight"] = weight
        }
        if let duration = duration {
            dict["duration"] = duration
        }
        if let distance = distance {
            dict["distance"] = distance
        }
        if let speed = speed {
            dict["speed"] = speed
        }
        if let resistance = resistance {
            dict["resistance"] = resistance
        }
        if let rpm = rpm {
            dict["rpm"] = rpm
        }
        if let calories = calories {
            dict["calories"] = calories
        }
        if let heartRate = heartRate {
            dict["heartRate"] = heartRate
        }
        if let notes = notes {
            dict["notes"] = notes
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> WorkoutSet? {
        guard let setNumber = data["setNumber"] as? Int else {
            return nil
        }
        
        let reps = data["reps"] as? Int
        let weight = data["weight"] as? Double
        let duration = data["duration"] as? TimeInterval
        let distance = data["distance"] as? Double
        let speed = data["speed"] as? Double
        let resistance = data["resistance"] as? Int
        let rpm = data["rpm"] as? Int
        let calories = data["calories"] as? Double
        let heartRate = data["heartRate"] as? Int
        let notes = data["notes"] as? String
        
        return WorkoutSet(
            setNumber: setNumber,
            reps: reps,
            weight: weight,
            duration: duration,
            distance: distance,
            speed: speed,
            resistance: resistance,
            rpm: rpm,
            calories: calories,
            heartRate: heartRate,
            notes: notes
        )
    }
}

struct MealLog: Codable {
    let mealPlanId: String?
    let mealType: MealType
    let items: [ConsumedFoodItem]
    let totalCalories: Double?
    let mealTime: MealTime
    let preparationTime: TimeInterval?
    let cookingTime: TimeInterval?
    let satisfaction: Int? // 1-10 scale
    let hungerBefore: Int? // 1-10 scale
    let hungerAfter: Int? // 1-10 scale
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "mealType": mealType.rawValue,
            "items": items.map { $0.toDictionary() },
            "mealTime": mealTime.rawValue,
            "schemaVersion": schemaVersion
        ]
        
        if let mealPlanId = mealPlanId {
            dict["mealPlanId"] = mealPlanId
        }
        if let totalCalories = totalCalories {
            dict["totalCalories"] = totalCalories
        }
        if let preparationTime = preparationTime {
            dict["preparationTime"] = preparationTime
        }
        if let cookingTime = cookingTime {
            dict["cookingTime"] = cookingTime
        }
        if let satisfaction = satisfaction {
            dict["satisfaction"] = satisfaction
        }
        if let hungerBefore = hungerBefore {
            dict["hungerBefore"] = hungerBefore
        }
        if let hungerAfter = hungerAfter {
            dict["hungerAfter"] = hungerAfter
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> MealLog? {
        guard let mealTypeString = data["mealType"] as? String,
              let mealType = MealType(rawValue: mealTypeString),
              let mealTimeString = data["mealTime"] as? String,
              let mealTime = MealTime(rawValue: mealTimeString) else {
            return nil
        }
        
        let mealPlanId = data["mealPlanId"] as? String
        let itemsData = data["items"] as? [[String: Any]] ?? []
        let items = itemsData.compactMap { ConsumedFoodItem.fromDictionary($0) }
        let totalCalories = data["totalCalories"] as? Double
        let preparationTime = data["preparationTime"] as? TimeInterval
        let cookingTime = data["cookingTime"] as? TimeInterval
        let satisfaction = data["satisfaction"] as? Int
        let hungerBefore = data["hungerBefore"] as? Int
        let hungerAfter = data["hungerAfter"] as? Int
        
        return MealLog(
            mealPlanId: mealPlanId,
            mealType: mealType,
            items: items,
            totalCalories: totalCalories,
            mealTime: mealTime,
            preparationTime: preparationTime,
            cookingTime: cookingTime,
            satisfaction: satisfaction,
            hungerBefore: hungerBefore,
            hungerAfter: hungerAfter
        )
    }
}

struct ConsumedFoodItem: Codable, Identifiable {
    var id: String { foodId }
    let foodId: String
    let name: String
    let quantity: Double
    let unit: String
    let calories: Double
    let notes: String?
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "foodId": foodId,
            "name": name,
            "quantity": quantity,
            "unit": unit,
            "calories": calories
        ]
        
        if let notes = notes {
            dict["notes"] = notes
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> ConsumedFoodItem? {
        guard let foodId = data["foodId"] as? String,
              let name = data["name"] as? String,
              let quantity = data["quantity"] as? Double,
              let unit = data["unit"] as? String,
              let calories = data["calories"] as? Double else {
            return nil
        }
        
        let notes = data["notes"] as? String
        
        return ConsumedFoodItem(
            foodId: foodId,
            name: name,
            quantity: quantity,
            unit: unit,
            calories: calories,
            notes: notes
        )
    }
}

enum MealTime: String, Codable, CaseIterable {
    case breakfast = "breakfast"
    case morningSnack = "morning_snack"
    case lunch = "lunch"
    case afternoonSnack = "afternoon_snack"
    case dinner = "dinner"
    case eveningSnack = "evening_snack"
    case preWorkout = "pre_workout"
    case postWorkout = "post_workout"
    case custom = "custom"
}

struct CustomActivityLog: Codable {
    let activityName: String
    let category: CustomActivityCategory
    let calories: Double?
    let duration: TimeInterval?
    let distance: Double?
    let steps: Int?
    let heartRate: Double?
    let notes: String?
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "activityName": activityName,
            "category": category.rawValue,
            "schemaVersion": schemaVersion
        ]
        
        if let calories = calories {
            dict["calories"] = calories
        }
        if let duration = duration {
            dict["duration"] = duration
        }
        if let distance = distance {
            dict["distance"] = distance
        }
        if let steps = steps {
            dict["steps"] = steps
        }
        if let heartRate = heartRate {
            dict["heartRate"] = heartRate
        }
        if let notes = notes {
            dict["notes"] = notes
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> CustomActivityLog? {
        guard let activityName = data["activityName"] as? String,
              let categoryString = data["category"] as? String,
              let category = CustomActivityCategory(rawValue: categoryString) else {
            return nil
        }
        
        let calories = data["calories"] as? Double
        let duration = data["duration"] as? TimeInterval
        let distance = data["distance"] as? Double
        let steps = data["steps"] as? Int
        let heartRate = data["heartRate"] as? Double
        let notes = data["notes"] as? String
        
        return CustomActivityLog(
            activityName: activityName,
            category: category,
            calories: calories,
            duration: duration,
            distance: distance,
            steps: steps,
            heartRate: heartRate,
            notes: notes
        )
    }
}

enum CustomActivityCategory: String, Codable, CaseIterable {
    case walking = "walking"
    case running = "running"
    case cycling = "cycling"
    case swimming = "swimming"
    case hiking = "hiking"
    case dancing = "dancing"
    case household = "household"
    case work = "work"
    case play = "play"
    case transportation = "transportation"
    case custom = "custom"
}

struct DeviceDataLog: Codable {
    let deviceType: DeviceType
    let deviceId: String?
    let dataType: DeviceDataType
    let value: Double
    let unit: String
    let startTime: Date?
    let endTime: Date?
    let metadata: [String: String]?
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "deviceType": deviceType.rawValue,
            "dataType": dataType.rawValue,
            "value": value,
            "unit": unit,
            "schemaVersion": schemaVersion
        ]
        
        if let deviceId = deviceId {
            dict["deviceId"] = deviceId
        }
        if let startTime = startTime {
            dict["startTime"] = startTime
        }
        if let endTime = endTime {
            dict["endTime"] = endTime
        }
        if let metadata = metadata {
            dict["metadata"] = metadata
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> DeviceDataLog? {
        guard let deviceTypeString = data["deviceType"] as? String,
              let deviceType = DeviceType(rawValue: deviceTypeString),
              let dataTypeString = data["dataType"] as? String,
              let dataType = DeviceDataType(rawValue: dataTypeString),
              let value = data["value"] as? Double,
              let unit = data["unit"] as? String else {
            return nil
        }
        
        let deviceId = data["deviceId"] as? String
        let startTime = data["startTime"] as? Date
        let endTime = data["endTime"] as? Date
        let metadata = data["metadata"] as? [String: String]
        
        return DeviceDataLog(
            deviceType: deviceType,
            deviceId: deviceId,
            dataType: dataType,
            value: value,
            unit: unit,
            startTime: startTime,
            endTime: endTime,
            metadata: metadata
        )
    }
}

enum DeviceType: String, Codable, CaseIterable {
    case appleWatch = "apple_watch"
    case fitbit = "fitbit"
    case garmin = "garmin"
    case polar = "polar"
    case samsung = "samsung"
    case xiaomi = "xiaomi"
    case huawei = "huawei"
    case custom = "custom"
}

enum DeviceDataType: String, Codable, CaseIterable {
    case heartRate = "heart_rate"
    case steps = "steps"
    case calories = "calories"
    case distance = "distance"
    case sleep = "sleep"
    case stress = "stress"
    case bloodPressure = "blood_pressure"
    case bloodOxygen = "blood_oxygen"
    case temperature = "temperature"
    case ecg = "ecg"
    case custom = "custom"
} 