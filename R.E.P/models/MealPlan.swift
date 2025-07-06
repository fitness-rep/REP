//
//  MealPlans.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//

struct MealPlan: Codable, Identifiable {
    var id: String { documentId }
    let documentId: String
    let description: String
    let createdBy: String
    let meals: [Meal]
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "documentId": documentId,
            "description": description,
            "createdBy": createdBy,
            "meals": meals.map { $0.toDictionary() },
            "schemaVersion": schemaVersion
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> MealPlan? {
        guard let documentId = data["documentId"] as? String,
              let description = data["description"] as? String,
              let createdBy = data["createdBy"] as? String else {
            return nil
        }
        
        let mealsData = data["meals"] as? [[String: Any]] ?? []
        let meals = mealsData.compactMap { Meal.fromDictionary($0) }
        
        return MealPlan(
            documentId: documentId,
            description: description,
            createdBy: createdBy,
            meals: meals
        )
    }
}

struct Meal: Codable, Identifiable {
    var id: String { mealId }
    let mealId: String
    let order: Int
    let type: MealType
    let progression: [MealProgression]
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "mealId": mealId,
            "order": order,
            "type": type.rawValue,
            "progression": progression.map { $0.toDictionary() },
            "schemaVersion": schemaVersion
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> Meal? {
        guard let mealId = data["mealId"] as? String,
              let order = data["order"] as? Int,
              let typeString = data["type"] as? String,
              let type = MealType(rawValue: typeString) else {
            return nil
        }
        
        let progressionData = data["progression"] as? [[String: Any]] ?? []
        let progression = progressionData.compactMap { MealProgression.fromDictionary($0) }
        
        return Meal(
            mealId: mealId,
            order: order,
            type: type,
            progression: progression
        )
    }
}

enum MealType: String, Codable, CaseIterable {
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

struct MealProgression: Codable {
    let startDay: Int
    let endDay: Int
    let order: Int
    let items: [MealItem]
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "startDay": startDay,
            "endDay": endDay,
            "order": order,
            "items": items.map { $0.toDictionary() },
            "schemaVersion": schemaVersion
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> MealProgression? {
        guard let startDay = data["startDay"] as? Int,
              let endDay = data["endDay"] as? Int,
              let order = data["order"] as? Int else {
            return nil
        }
        
        let itemsData = data["items"] as? [[String: Any]] ?? []
        let items = itemsData.compactMap { MealItem.fromDictionary($0) }
        
        return MealProgression(
            startDay: startDay,
            endDay: endDay,
            order: order,
            items: items
        )
    }
}

struct MealItem: Codable, Identifiable {
    var id: String { foodId }
    let foodId: String // Must match documentId in foods collection
    let quantity: Double
    let unit: String
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "foodId": foodId,
            "quantity": quantity,
            "unit": unit,
            "schemaVersion": schemaVersion
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> MealItem? {
        guard let foodId = data["foodId"] as? String,
              let quantity = data["quantity"] as? Double,
              let unit = data["unit"] as? String else {
            return nil
        }
        
        return MealItem(
            foodId: foodId,
            quantity: quantity,
            unit: unit
        )
    }
}
