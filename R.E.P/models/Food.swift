//
//  Food.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//

struct Food: Codable, Identifiable {
    var id: String { documentId }
    let documentId: String
    let name: String
    let category: FoodCategory
    let defaultQuantity: Double
    let defaultUnit: String
    let nutrition: FoodNutrition
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "documentId": documentId,
            "name": name,
            "category": category.rawValue,
            "defaultQuantity": defaultQuantity,
            "defaultUnit": defaultUnit,
            "nutrition": nutrition.toDictionary(),
            "schemaVersion": schemaVersion
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> Food? {
        guard let documentId = data["documentId"] as? String,
              let name = data["name"] as? String,
              let categoryString = data["category"] as? String,
              let category = FoodCategory(rawValue: categoryString),
              let defaultQuantity = data["defaultQuantity"] as? Double,
              let defaultUnit = data["defaultUnit"] as? String,
              let nutritionData = data["nutrition"] as? [String: Any],
              let nutrition = FoodNutrition.fromDictionary(nutritionData) else {
            return nil
        }
        
        return Food(
            documentId: documentId,
            name: name,
            category: category,
            defaultQuantity: defaultQuantity,
            defaultUnit: defaultUnit,
            nutrition: nutrition
        )
    }
}

enum FoodCategory: String, Codable, CaseIterable {
    case fruits = "fruits"
    case vegetables = "vegetables"
    case grains = "grains"
    case proteins = "proteins"
    case dairy = "dairy"
    case nuts = "nuts"
    case seeds = "seeds"
    case legumes = "legumes"
    case beverages = "beverages"
    case snacks = "snacks"
    case condiments = "condiments"
    case spices = "spices"
    case supplements = "supplements"
    case processed = "processed"
    case custom = "custom"
}

struct FoodNutrition: Codable {
    let calories: Double
    let carbs: Double
    let fat: Double
    let fiber: Double
    let protien: Double // Note: spelling matches your JSON
    let sugar: Double
    
    // Basic versioning for future extensibility
    let schemaVersion: Int = 1
    
    // Manual dictionary conversion methods
    func toDictionary() -> [String: Any] {
        return [
            "calories": calories,
            "carbs": carbs,
            "fat": fat,
            "fiber": fiber,
            "protien": protien,
            "sugar": sugar,
            "schemaVersion": schemaVersion
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> FoodNutrition? {
        guard let calories = data["calories"] as? Double,
              let carbs = data["carbs"] as? Double,
              let fat = data["fat"] as? Double,
              let fiber = data["fiber"] as? Double,
              let protien = data["protien"] as? Double,
              let sugar = data["sugar"] as? Double else {
            return nil
        }
        
        return FoodNutrition(
            calories: calories,
            carbs: carbs,
            fat: fat,
            fiber: fiber,
            protien: protien,
            sugar: sugar
        )
    }
}
