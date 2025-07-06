//
//  User.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//
import Foundation

// Gender enum for registration flow
enum Gender: String, CaseIterable {
    case male = "male"
    case female = "female"
}

// Mutable User class for registration flow
class RegistrationUser: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var gender: String = "male"
    @Published var age: Double = 0.0
    @Published var height: Double = 0.0
    @Published var weight: Double = 0.0
    @Published var fitnessGoal: String = ""
    @Published var strengthExperience: String = ""
    @Published var experienceLevel: String = ""
    @Published var gymChallenge: String = ""
    @Published var strengthRoutine: String = ""
    @Published var exerciseLocation: String = ""
    @Published var workoutDuration: Double = 0.0
    @Published var foodPreference: String = ""
    @Published var isTakingMedications: Bool = false
    @Published var medications: String = ""
    @Published var hasInjuries: Bool = false
    @Published var injuries: String = ""
    
    init() {}
    
    // Convert to immutable User struct
    func toUser(uid: String) -> User {
        return User(
            uid: uid,
            name: name,
            email: email,
            gender: gender,
            age: age,
            height: height,
            weight: weight,
            fitnessGoal: fitnessGoal,
            strengthExperience: strengthExperience,
            experienceLevel: experienceLevel,
            gymChallenge: gymChallenge,
            strengthRoutine: strengthRoutine,
            exerciseLocation: exerciseLocation,
            workoutDuration: workoutDuration,
            foodPreference: foodPreference,
            isTakingMedications: isTakingMedications,
            medications: medications,
            hasInjuries: hasInjuries,
            injuries: injuries,
            registrationDate: Date(),
            currentRoutineId: nil,
            goals: []
        )
    }
    
    // Validate that all required fields are filled
    var isComplete: Bool {
        return !name.isEmpty && 
               !email.isEmpty && 
               age > 0 && 
               height > 0 && 
               weight > 0 && 
               !fitnessGoal.isEmpty
    }
    
    // Get validation errors
    var validationErrors: [String] {
        var errors: [String] = []
        
        if name.isEmpty {
            errors.append("Name is required")
        }
        if email.isEmpty {
            errors.append("Email is required")
        }
        if age <= 0 {
            errors.append("Valid age is required")
        }
        if height <= 0 {
            errors.append("Valid height is required")
        }
        if weight <= 0 {
            errors.append("Valid weight is required")
        }
        if fitnessGoal.isEmpty {
            errors.append("Fitness goal is required")
        }
        
        return errors
    }
    
    // Print all properties for debugging
    func printProperties(context: String = "") {
        print("=== RegistrationUser Properties \(context) ===")
        print("name: '\(name)'")
        print("email: '\(email)'")
        print("gender: '\(gender)'")
        print("age: \(age)")
        print("height: \(height)")
        print("weight: \(weight)")
        print("fitnessGoal: '\(fitnessGoal)'")
        print("strengthExperience: '\(strengthExperience)'")
        print("experienceLevel: '\(experienceLevel)'")
        print("gymChallenge: '\(gymChallenge)'")
        print("strengthRoutine: '\(strengthRoutine)'")
        print("exerciseLocation: '\(exerciseLocation)'")
        print("workoutDuration: '\(workoutDuration)'")
        print("foodPreference: '\(foodPreference)'")
        print("isTakingMedications: \(isTakingMedications)")
        print("medications: '\(medications)'")
        print("hasInjuries: \(hasInjuries)")
        print("injuries: '\(injuries)'")
        print("==========================================")
    }
}

struct User: Codable, Identifiable {
    var id: String { uid }
    let uid: String
    let name: String
    let email: String
    let gender: String
    let age: Double
    let height: Double
    let weight: Double
    let fitnessGoal: String
    let strengthExperience: String
    let experienceLevel: String
    let gymChallenge: String
    let strengthRoutine: String
    let exerciseLocation: String
    let workoutDuration: Double
    let foodPreference: String
    let isTakingMedications: Bool
    let medications: String
    let hasInjuries: Bool
    let injuries: String
    let registrationDate: Date
    var currentRoutineId: String?
    var goals: [Goal]
    
    // Basic versioning for future extensibility
    var schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "name": name,
            "email": email,
            "gender": gender,
            "age": age,
            "height": height,
            "weight": weight,
            "fitnessGoal": fitnessGoal,
            "strengthExperience": strengthExperience,
            "experienceLevel": experienceLevel,
            "gymChallenge": gymChallenge,
            "strengthRoutine": strengthRoutine,
            "exerciseLocation": exerciseLocation,
            "workoutDuration": workoutDuration,
            "foodPreference": foodPreference,
            "isTakingMedications": isTakingMedications,
            "medications": medications,
            "hasInjuries": hasInjuries,
            "injuries": injuries,
            "registrationDate": registrationDate,
            "currentRoutineId": currentRoutineId as Any,
            "goals": goals.map { $0.toDictionary() },
            "schemaVersion": schemaVersion
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> User? {
        guard let uid = data["uid"] as? String,
              let name = data["name"] as? String,
              let email = data["email"] as? String,
              let gender = data["gender"] as? String,
              let age = data["age"] as? Double,
              let height = data["height"] as? Double,
              let weight = data["weight"] as? Double,
              let fitnessGoal = data["fitnessGoal"] as? String,
              let strengthExperience = data["strengthExperience"] as? String,
              let experienceLevel = data["experienceLevel"] as? String,
              let gymChallenge = data["gymChallenge"] as? String,
              let strengthRoutine = data["strengthRoutine"] as? String,
              let exerciseLocation = data["exerciseLocation"] as? String,
              let workoutDuration = data["workoutDuration"] as? Double,
              let foodPreference = data["foodPreference"] as? String,
              let isTakingMedications = data["isTakingMedications"] as? Bool,
              let medications = data["medications"] as? String,
              let hasInjuries = data["hasInjuries"] as? Bool,
              let injuries = data["injuries"] as? String,
              let registrationDate = data["registrationDate"] as? Date else {
            return nil
        }
        
        let currentRoutineId = data["currentRoutineId"] as? String
        let goalsData = data["goals"] as? [[String: Any]] ?? []
        let goals = goalsData.compactMap { Goal.fromDictionary($0) }
        
        return User(
            uid: uid,
            name: name,
            email: email,
            gender: gender,
            age: age,
            height: height,
            weight: weight,
            fitnessGoal: fitnessGoal,
            strengthExperience: strengthExperience,
            experienceLevel: experienceLevel,
            gymChallenge: gymChallenge,
            strengthRoutine: strengthRoutine,
            exerciseLocation: exerciseLocation,
            workoutDuration: workoutDuration,
            foodPreference: foodPreference,
            isTakingMedications: isTakingMedications,
            medications: medications,
            hasInjuries: hasInjuries,
            injuries: injuries,
            registrationDate: registrationDate,
            currentRoutineId: currentRoutineId,
            goals: goals
        )
    }
}

struct Goal: Codable, Identifiable {
    var id: String { goalId }
    let goalId: String
    let description: String
    let targetDate: Date
    var progress: Double
    let routineId: String
    
    // Basic versioning for future extensibility
    var schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "goalId": goalId,
            "description": description,
            "targetDate": targetDate,
            "progress": progress,
            "routineId": routineId,
            "schemaVersion": schemaVersion
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> Goal? {
        guard let goalId = data["goalId"] as? String,
              let description = data["description"] as? String,
              let targetDate = data["targetDate"] as? Date,
              let progress = data["progress"] as? Double,
              let routineId = data["routineId"] as? String else {
            return nil
        }
        
        return Goal(
            goalId: goalId,
            description: description,
            targetDate: targetDate,
            progress: progress,
            routineId: routineId
        )
    }
}
