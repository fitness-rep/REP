//
//  User.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//
import Foundation
import FirebaseFirestore

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
    @Published var gymChallenge: Set<GymChallenge> = []
    @Published var strengthRoutine: Set<StrengthRoutine> = []
    @Published var exerciseLocation: String = ""
    @Published var workoutDuration: Double = 0.0
    @Published var trainingWindowStart: String = "06:00"
    @Published var trainingWindowEnd: String = "08:00"
    @Published var foodPreference: String = ""
    @Published var isTakingMedications: Bool = false
    @Published var medications: String = ""
    @Published var hasInjuries: Bool = false
    @Published var injuries: String = ""
    
    // Target Weight View data
    @Published var targetWeight: Double = 70.0
    @Published var targetWeightUnit: String = "kg"
    
    // Training Focus View data
    @Published var trainingFocusAreas: Set<String> = []
    
    // Schedule Preference View data
    @Published var scheduleType: String = "smart"
    @Published var smartScheduleWorkoutsPerWeek: Int? = nil
    @Published var fixedScheduleDays: Set<String>? = nil
    
    // Height and Weight units
    @Published var heightUnit: String = "cm"
    @Published var weightUnit: String = "kg"
    
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
            trainingWindowStart: trainingWindowStart,
            trainingWindowEnd: trainingWindowEnd,
            foodPreference: foodPreference,
            isTakingMedications: isTakingMedications,
            medications: medications,
            hasInjuries: hasInjuries,
            injuries: injuries,
            targetWeight: targetWeight,
            targetWeightUnit: targetWeightUnit,
            trainingFocusAreas: trainingFocusAreas,
            scheduleType: scheduleType,
            smartScheduleWorkoutsPerWeek: smartScheduleWorkoutsPerWeek,
            fixedScheduleDays: fixedScheduleDays,
            heightUnit: heightUnit,
            weightUnit: weightUnit,
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
        print("gymChallenge: \(gymChallenge.map { $0.rawValue })")
        print("strengthRoutine: \(strengthRoutine.map { $0.rawValue })")
        print("exerciseLocation: '\(exerciseLocation)'")
        print("workoutDuration: '\(workoutDuration)'")
        print("trainingWindowStart: '\(trainingWindowStart)'")
        print("trainingWindowEnd: '\(trainingWindowEnd)'")
        print("foodPreference: '\(foodPreference)'")
        print("isTakingMedications: \(isTakingMedications)")
        print("medications: '\(medications)'")
        print("hasInjuries: \(hasInjuries)")
        print("injuries: '\(injuries)'")
        print("targetWeight: \(targetWeight)")
        print("targetWeightUnit: '\(targetWeightUnit)'")
        print("trainingFocusAreas: \(trainingFocusAreas)")
        print("scheduleType: '\(scheduleType)'")
        print("smartScheduleWorkoutsPerWeek: \(smartScheduleWorkoutsPerWeek ?? -1)")
        print("fixedScheduleDays: \(fixedScheduleDays ?? [])")
        print("heightUnit: '\(heightUnit)'")
        print("weightUnit: '\(weightUnit)'")
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
    let gymChallenge: Set<GymChallenge>
    let strengthRoutine: Set<StrengthRoutine>
    let exerciseLocation: String
    let workoutDuration: Double
    let trainingWindowStart: String
    let trainingWindowEnd: String
    let foodPreference: String
    let isTakingMedications: Bool
    let medications: String
    let hasInjuries: Bool
    let injuries: String
    
    // Target Weight View data
    let targetWeight: Double
    let targetWeightUnit: String // "kg" or "lbs"
    
    // Training Focus View data
    let trainingFocusAreas: Set<String> // Set of TrainingArea raw values
    
    // Schedule Preference View data
    let scheduleType: String // "smart" or "fixed"
    let smartScheduleWorkoutsPerWeek: Int? // if scheduleType is "smart"
    let fixedScheduleDays: Set<String>? // if scheduleType is "fixed"
    
    // Height and Weight units
    let heightUnit: String // "cm" or "feet"
    let weightUnit: String // "kg" or "lbs"
    
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
            "gymChallenge": gymChallenge.map { $0.rawValue },
            "strengthRoutine": strengthRoutine.map { $0.rawValue },
            "exerciseLocation": exerciseLocation,
            "workoutDuration": workoutDuration,
            "trainingWindowStart": trainingWindowStart,
            "trainingWindowEnd": trainingWindowEnd,
            "foodPreference": foodPreference,
            "isTakingMedications": isTakingMedications,
            "medications": medications,
            "hasInjuries": hasInjuries,
            "injuries": injuries,
            "targetWeight": targetWeight,
            "targetWeightUnit": targetWeightUnit,
            "trainingFocusAreas": Array(trainingFocusAreas),
            "scheduleType": scheduleType,
            "smartScheduleWorkoutsPerWeek": smartScheduleWorkoutsPerWeek as Any,
            "fixedScheduleDays": fixedScheduleDays != nil ? Array(fixedScheduleDays!) : nil,
            "heightUnit": heightUnit,
            "weightUnit": weightUnit,
            "registrationDate": Timestamp(date: registrationDate),
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
              let exerciseLocation = data["exerciseLocation"] as? String,
              let workoutDuration = data["workoutDuration"] as? Double,
              let foodPreference = data["foodPreference"] as? String,
              let isTakingMedications = data["isTakingMedications"] as? Bool,
              let medications = data["medications"] as? String,
              let hasInjuries = data["hasInjuries"] as? Bool,
              let injuries = data["injuries"] as? String else {
            return nil
        }
        
        // Handle training window as strings
        let trainingWindowStart = data["trainingWindowStart"] as? String ?? "06:00"
        let trainingWindowEnd = data["trainingWindowEnd"] as? String ?? "08:00"
        
        let registrationDate: Date
        if let timestamp = data["registrationDate"] as? Timestamp {
            registrationDate = timestamp.dateValue()
        } else if let date = data["registrationDate"] as? Date {
            registrationDate = date
        } else {
            registrationDate = Date()
        }
        // Handle gymChallenge conversion from array of strings to Set<GymChallenge>
        let gymChallengeStrings = data["gymChallenge"] as? [String] ?? []
        let gymChallenge: Set<GymChallenge> = Set(gymChallengeStrings.compactMap { string in
            GymChallenge(rawValue: string)
        })
        // Handle strengthRoutine conversion from array of strings to Set<StrengthRoutine>
        let strengthRoutineStrings = data["strengthRoutine"] as? [String] ?? []
        let strengthRoutine: Set<StrengthRoutine> = Set(strengthRoutineStrings.compactMap { string in
            StrengthRoutine(rawValue: string)
        })
        let currentRoutineId = data["currentRoutineId"] as? String
        let goalsData = data["goals"] as? [[String: Any]] ?? []
        let goals = goalsData.compactMap { Goal.fromDictionary($0) }
        
        // Handle new fields with defaults
        let targetWeight = data["targetWeight"] as? Double ?? 70.0
        let targetWeightUnit = data["targetWeightUnit"] as? String ?? "kg"
        
        let trainingFocusAreasStrings = data["trainingFocusAreas"] as? [String] ?? []
        let trainingFocusAreas: Set<String> = Set(trainingFocusAreasStrings)
        
        let scheduleType = data["scheduleType"] as? String ?? "smart"
        let smartScheduleWorkoutsPerWeek = data["smartScheduleWorkoutsPerWeek"] as? Int
        let fixedScheduleDaysStrings = data["fixedScheduleDays"] as? [String]
        let fixedScheduleDays: Set<String>? = fixedScheduleDaysStrings != nil ? Set(fixedScheduleDaysStrings!) : nil
        
        let heightUnit = data["heightUnit"] as? String ?? "cm"
        let weightUnit = data["weightUnit"] as? String ?? "kg"
        
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
            trainingWindowStart: trainingWindowStart,
            trainingWindowEnd: trainingWindowEnd,
            foodPreference: foodPreference,
            isTakingMedications: isTakingMedications,
            medications: medications,
            hasInjuries: hasInjuries,
            injuries: injuries,
            targetWeight: targetWeight,
            targetWeightUnit: targetWeightUnit,
            trainingFocusAreas: trainingFocusAreas,
            scheduleType: scheduleType,
            smartScheduleWorkoutsPerWeek: smartScheduleWorkoutsPerWeek,
            fixedScheduleDays: fixedScheduleDays,
            heightUnit: heightUnit,
            weightUnit: weightUnit,
            registrationDate: registrationDate,
            currentRoutineId: currentRoutineId,
            goals: goals
        )
    }
}
