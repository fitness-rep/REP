//
//  ExercisePlan.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//

import Foundation
import FirebaseFirestore

struct ExercisePlan: Codable, Identifiable {
    var id: String { documentId }
    let documentId: String
    let createdBy: String
    let description: String
    let exercises: [Exercise]
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "documentId": documentId,
            "createdBy": createdBy,
            "description": description,
            "exercises": exercises.map { $0.toDictionary() },
            "schemaVersion": schemaVersion
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> ExercisePlan? {
        guard let documentId = data["documentId"] as? String,
              let createdBy = data["createdBy"] as? String,
              let description = data["description"] as? String else {
            return nil
        }
        
        let exercisesData = data["exercises"] as? [[String: Any]] ?? []
        let exercises = exercisesData.compactMap { Exercise.fromDictionary($0) }
        
        return ExercisePlan(
            documentId: documentId,
            createdBy: createdBy,
            description: description,
            exercises: exercises
        )
    }
}

struct Exercise: Codable, Identifiable {
    var id: String { "\(templateId)_\(progression.first?.order ?? 0)" }
    let templateId: String  // Reference to ExerciseTemplate
    let progression: [ExerciseProgression]
    
    // Computed property to get template info (will be fetched separately)
    var template: ExerciseTemplate?
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "templateId": templateId,
            "progression": progression.map { $0.toDictionary() },
            "schemaVersion": schemaVersion
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> Exercise? {
        guard let templateId = data["templateId"] as? String else {
            return nil
        }
        
        let progressionData = data["progression"] as? [[String: Any]] ?? []
        let progression = progressionData.compactMap { ExerciseProgression.fromDictionary($0) }
        
        return Exercise(
            templateId: templateId,
            progression: progression
        )
    }
}

struct ExerciseTemplate: Codable, Identifiable {
    var id: String { templateId }
    let templateId: String
    let name: String
    let type: ExerciseType
    let description: String?
    let muscleGroups: [String]?
    let equipment: [String]?
    let difficulty: String?
    let instructions: String?
    let videoUrl: String?
    let imageUrl: String?
    let isActive: Bool
    let createdBy: String?
    let createdAt: Date
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "templateId": templateId,
            "name": name,
            "type": type.rawValue,
            "isActive": isActive,
            "createdAt": Timestamp(date: createdAt),
            "schemaVersion": schemaVersion
        ]
        
        if let description = description {
            dict["description"] = description
        }
        if let muscleGroups = muscleGroups {
            dict["muscleGroups"] = muscleGroups
        }
        if let equipment = equipment {
            dict["equipment"] = equipment
        }
        if let difficulty = difficulty {
            dict["difficulty"] = difficulty
        }
        if let instructions = instructions {
            dict["instructions"] = instructions
        }
        if let videoUrl = videoUrl {
            dict["videoUrl"] = videoUrl
        }
        if let imageUrl = imageUrl {
            dict["imageUrl"] = imageUrl
        }
        if let createdBy = createdBy {
            dict["createdBy"] = createdBy
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> ExerciseTemplate? {
        guard let templateId = data["templateId"] as? String,
              let name = data["name"] as? String,
              let typeString = data["type"] as? String,
              let type = ExerciseType(rawValue: typeString),
              let isActive = data["isActive"] as? Bool else {
            return nil
        }
        
        let description = data["description"] as? String
        let muscleGroups = data["muscleGroups"] as? [String]
        let equipment = data["equipment"] as? [String]
        let difficulty = data["difficulty"] as? String
        let instructions = data["instructions"] as? String
        let videoUrl = data["videoUrl"] as? String
        let imageUrl = data["imageUrl"] as? String
        let createdBy = data["createdBy"] as? String
        
        let createdAt: Date
        if let timestamp = data["createdAt"] as? Timestamp {
            createdAt = timestamp.dateValue()
        } else {
            createdAt = Date()
        }
        
        return ExerciseTemplate(
            templateId: templateId,
            name: name,
            type: type,
            description: description,
            muscleGroups: muscleGroups,
            equipment: equipment,
            difficulty: difficulty,
            instructions: instructions,
            videoUrl: videoUrl,
            imageUrl: imageUrl,
            isActive: isActive,
            createdBy: createdBy,
            createdAt: createdAt
        )
    }
}

enum ExerciseType: String, Codable, CaseIterable {
    case strength = "strength"
    case cardio = "cardio"
    case flexibility = "flexibility"
    case balance = "balance"
    case plyometric = "plyometric"
    case yoga = "yoga"
    case pilates = "pilates"
    case hiit = "hiit"
    case endurance = "endurance"
    case powerlifting = "powerlifting"
    case olympic = "olympic"
    case calisthenics = "calisthenics"
    case sports = "sports"
    case rehabilitation = "rehabilitation"
    case custom = "custom"
}

struct ExerciseProgression: Codable {
    let order: Int
    let startDay: Int
    let endDay: Int
    let restSeconds: Int?
    
    // For simple exercises (Strength, etc.)
    let reps: Int?
    let sets: Int?
    
    // For complex exercises (Cardio with set-specific data)
    let setsDetail: [ExerciseSet]?
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Custom CodingKeys to map "sets" in JSON to "setsDetail" in Swift
    private enum CodingKeys: String, CodingKey {
        case order, startDay, endDay, restSeconds, reps, sets, setsDetail, schemaVersion
    }
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "order": order,
            "startDay": startDay,
            "endDay": endDay,
            "schemaVersion": schemaVersion
        ]
        
        if let restSeconds = restSeconds {
            dict["restSeconds"] = restSeconds
        }
        if let reps = reps {
            dict["reps"] = reps
        }
        if let sets = sets {
            dict["sets"] = sets
        }
        if let setsDetail = setsDetail {
            dict["sets"] = setsDetail.map { $0.toDictionary() }
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> ExerciseProgression? {
        guard let order = data["order"] as? Int,
              let startDay = data["startDay"] as? Int,
              let endDay = data["endDay"] as? Int else {
            return nil
        }
        
        let restSeconds = data["restSeconds"] as? Int
        let reps = data["reps"] as? Int
        let sets = data["sets"] as? Int
        
        let setsDetailData = data["sets"] as? [[String: Any]]
        let setsDetail = setsDetailData?.compactMap { ExerciseSet.fromDictionary($0) }
        
        return ExerciseProgression(
            order: order,
            startDay: startDay,
            endDay: endDay,
            restSeconds: restSeconds,
            reps: reps,
            sets: sets,
            setsDetail: setsDetail
        )
    }
}

struct ExerciseSet: Codable, Identifiable {
    var id: String { "\(setNumber)" }
    let setNumber: Int
    let durationMins: Int?
    let inclinationDegree: Double?
    let speedMphs: Double?
    let restSeconds: Int?
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "setNumber": setNumber,
            "schemaVersion": schemaVersion
        ]
        
        if let durationMins = durationMins {
            dict["durationMins"] = durationMins
        }
        if let inclinationDegree = inclinationDegree {
            dict["inclinationDegree"] = inclinationDegree
        }
        if let speedMphs = speedMphs {
            dict["speedMphs"] = speedMphs
        }
        if let restSeconds = restSeconds {
            dict["restSeconds"] = restSeconds
        }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> ExerciseSet? {
        guard let setNumber = data["setNumber"] as? Int else {
            return nil
        }
        
        let durationMins = data["durationMins"] as? Int
        let inclinationDegree = data["inclinationDegree"] as? Double
        let speedMphs = data["speedMphs"] as? Double
        let restSeconds = data["restSeconds"] as? Int
        
        return ExerciseSet(
            setNumber: setNumber,
            durationMins: durationMins,
            inclinationDegree: inclinationDegree,
            speedMphs: speedMphs,
            restSeconds: restSeconds
        )
    }
}
