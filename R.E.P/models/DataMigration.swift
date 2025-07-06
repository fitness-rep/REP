//
//  DataMigration.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//

import Foundation
import FirebaseFirestore

class DataMigration {
    static let shared = DataMigration()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Schema Version Management
    
    func getCurrentSchemaVersion(for collection: String) async throws -> Int {
        let doc = try await db.collection("schema_versions").document(collection).getDocument()
        return doc.data()?["version"] as? Int ?? 1
    }
    
    func updateSchemaVersion(for collection: String, to version: Int) async throws {
        try await db.collection("schema_versions").document(collection).setData([
            "version": version,
            "updatedAt": FieldValue.serverTimestamp()
        ])
    }
    
    // MARK: - User Data Migration
    
    func migrateUserData(from version: Int, to targetVersion: Int) async throws {
        guard version < targetVersion else { return }
        
        // Get all users that need migration
        let users = try await db.collection("users")
            .whereField("schemaVersion", isLessThan: targetVersion)
            .getDocuments()
        
        for document in users.documents {
            try await migrateUserDocument(document, from: version, to: targetVersion)
        }
    }
    
    private func migrateUserDocument(_ document: QueryDocumentSnapshot, from version: Int, to targetVersion: Int) async throws {
        var userData = document.data()
        
        // Apply migrations sequentially
        for v in version..<targetVersion {
            userData = try await applyUserMigration(userData, from: v, to: v + 1)
        }
        
        // Update the document
        try await document.reference.setData(userData, merge: true)
    }
    
    private func applyUserMigration(_ data: [String: Any], from version: Int, to targetVersion: Int) async throws -> [String: Any] {
        var migratedData = data
        
        switch version {
        case 1:
            // Migration from v1 to v2
            migratedData = migrateUserV1ToV2(migratedData)
        case 2:
            // Migration from v2 to v3
            migratedData = migrateUserV2ToV3(migratedData)
        default:
            // Add new migrations here
            break
        }
        
        migratedData["schemaVersion"] = targetVersion
        return migratedData
    }
    
    private func migrateUserV1ToV2(_ data: [String: Any]) -> [String: Any] {
        var migratedData = data
        
        // Add new fields with default values
        migratedData["metadata"] = [:]
        migratedData["healthMetrics"] = nil
        migratedData["preferences"] = nil
        migratedData["activityLevel"] = "moderate"
        migratedData["bodyComposition"] = nil
        migratedData["socialSettings"] = nil
        
        return migratedData
    }
    
    private func migrateUserV2ToV3(_ data: [String: Any]) -> [String: Any] {
        var migratedData = data
        
        // Example: Add new health metrics structure
        if migratedData["healthMetrics"] == nil {
            migratedData["healthMetrics"] = [
                "restingHeartRate": nil,
                "bloodPressure": nil,
                "bodyFatPercentage": nil,
                "muscleMass": nil,
                "boneDensity": nil,
                "hydrationLevel": nil,
                "sleepQuality": nil,
                "stressLevel": nil,
                "schemaVersion": 1
            ]
        }
        
        return migratedData
    }
    
    // MARK: - Exercise Plan Migration
    
    func migrateExercisePlanData(from version: Int, to targetVersion: Int) async throws {
        guard version < targetVersion else { return }
        
        let plans = try await db.collection("exercisePlans")
            .whereField("schemaVersion", isLessThan: targetVersion)
            .getDocuments()
        
        for document in plans.documents {
            try await migrateExercisePlanDocument(document, from: version, to: targetVersion)
        }
    }
    
    private func migrateExercisePlanDocument(_ document: QueryDocumentSnapshot, from version: Int, to targetVersion: Int) async throws {
        var planData = document.data()
        
        for v in version..<targetVersion {
            planData = try await applyExercisePlanMigration(planData, from: v, to: v + 1)
        }
        
        try await document.reference.setData(planData, merge: true)
    }
    
    private func applyExercisePlanMigration(_ data: [String: Any], from version: Int, to targetVersion: Int) async throws -> [String: Any] {
        var migratedData = data
        
        switch version {
        case 1:
            migratedData = migrateExercisePlanV1ToV2(migratedData)
        default:
            break
        }
        
        migratedData["schemaVersion"] = targetVersion
        return migratedData
    }
    
    private func migrateExercisePlanV1ToV2(_ data: [String: Any]) -> [String: Any] {
        var migratedData = data
        
        // Add new fields
        migratedData["difficulty"] = "intermediate"
        migratedData["estimatedDuration"] = nil
        migratedData["targetMuscleGroups"] = []
        migratedData["requiredEquipment"] = []
        migratedData["tags"] = []
        migratedData["isPublic"] = false
        migratedData["rating"] = nil
        migratedData["reviewCount"] = 0
        migratedData["aiGenerated"] = false
        migratedData["personalizationFactors"] = [:]
        
        return migratedData
    }
    
    // MARK: - Meal Plan Migration
    
    func migrateMealPlanData(from version: Int, to targetVersion: Int) async throws {
        guard version < targetVersion else { return }
        
        let plans = try await db.collection("mealPlans")
            .whereField("schemaVersion", isLessThan: targetVersion)
            .getDocuments()
        
        for document in plans.documents {
            try await migrateMealPlanDocument(document, from: version, to: targetVersion)
        }
    }
    
    private func migrateMealPlanDocument(_ document: QueryDocumentSnapshot, from version: Int, to targetVersion: Int) async throws {
        var planData = document.data()
        
        for v in version..<targetVersion {
            planData = try await applyMealPlanMigration(planData, from: v, to: v + 1)
        }
        
        try await document.reference.setData(planData, merge: true)
    }
    
    private func applyMealPlanMigration(_ data: [String: Any], from version: Int, to targetVersion: Int) async throws -> [String: Any] {
        var migratedData = data
        
        switch version {
        case 1:
            migratedData = migrateMealPlanV1ToV2(migratedData)
        default:
            break
        }
        
        migratedData["schemaVersion"] = targetVersion
        return migratedData
    }
    
    private func migrateMealPlanV1ToV2(_ data: [String: Any]) -> [String: Any] {
        var migratedData = data
        
        // Add new fields
        migratedData["difficulty"] = "intermediate"
        migratedData["estimatedCalories"] = nil
        migratedData["targetMacros"] = nil
        migratedData["dietaryRestrictions"] = []
        migratedData["cuisineType"] = []
        migratedData["prepTime"] = nil
        migratedData["cookTime"] = nil
        migratedData["servings"] = 1
        migratedData["tags"] = []
        migratedData["isPublic"] = false
        migratedData["rating"] = nil
        migratedData["reviewCount"] = 0
        migratedData["aiGenerated"] = false
        migratedData["personalizationFactors"] = [:]
        migratedData["nutritionalGoals"] = []
        
        return migratedData
    }
    
    // MARK: - Food Data Migration
    
    func migrateFoodData(from version: Int, to targetVersion: Int) async throws {
        guard version < targetVersion else { return }
        
        let foods = try await db.collection("foods")
            .whereField("schemaVersion", isLessThan: targetVersion)
            .getDocuments()
        
        for document in foods.documents {
            try await migrateFoodDocument(document, from: version, to: targetVersion)
        }
    }
    
    private func migrateFoodDocument(_ document: QueryDocumentSnapshot, from version: Int, to targetVersion: Int) async throws {
        var foodData = document.data()
        
        for v in version..<targetVersion {
            foodData = try await applyFoodMigration(foodData, from: v, to: v + 1)
        }
        
        try await document.reference.setData(foodData, merge: true)
    }
    
    private func applyFoodMigration(_ data: [String: Any], from version: Int, to targetVersion: Int) async throws -> [String: Any] {
        var migratedData = data
        
        switch version {
        case 1:
            migratedData = migrateFoodV1ToV2(migratedData)
        default:
            break
        }
        
        migratedData["schemaVersion"] = targetVersion
        return migratedData
    }
    
    private func migrateFoodV1ToV2(_ data: [String: Any]) -> [String: Any] {
        var migratedData = data
        
        // Add new fields
        migratedData["description"] = nil
        migratedData["brand"] = nil
        migratedData["barcode"] = nil
        migratedData["imageUrl"] = nil
        migratedData["tags"] = []
        migratedData["isVerified"] = false
        migratedData["source"] = "user_generated"
        migratedData["lastUpdated"] = nil
        migratedData["allergens"] = []
        migratedData["dietaryTags"] = []
        migratedData["ingredients"] = []
        migratedData["servingSize"] = nil
        migratedData["aiGenerated"] = false
        migratedData["personalizationFactors"] = [:]
        migratedData["isSeasonal"] = false
        migratedData["seasonalMonths"] = []
        migratedData["availability"] = "year_round"
        
        return migratedData
    }
    
    // MARK: - Batch Migration
    
    func migrateAllData() async throws {
        let collections = ["users", "exercisePlans", "mealPlans", "foods", "routines", "activityLogs"]
        
        for collection in collections {
            let currentVersion = try await getCurrentSchemaVersion(for: collection)
            let targetVersion = getTargetSchemaVersion(for: collection)
            
            if currentVersion < targetVersion {
                try await migrateCollection(collection, from: currentVersion, to: targetVersion)
                try await updateSchemaVersion(for: collection, to: targetVersion)
            }
        }
    }
    
    private func migrateCollection(_ collection: String, from version: Int, to targetVersion: Int) async throws {
        switch collection {
        case "users":
            try await migrateUserData(from: version, to: targetVersion)
        case "exercisePlans":
            try await migrateExercisePlanData(from: version, to: targetVersion)
        case "mealPlans":
            try await migrateMealPlanData(from: version, to: targetVersion)
        case "foods":
            try await migrateFoodData(from: version, to: targetVersion)
        default:
            break
        }
    }
    
    private func getTargetSchemaVersion(for collection: String) -> Int {
        switch collection {
        case "users", "exercisePlans", "mealPlans", "foods", "routines", "activityLogs":
            return 1 // Current version
        default:
            return 1
        }
    }
    
    // MARK: - Validation
    
    func validateMigration(_ collection: String) async throws -> Bool {
        let documents = try await db.collection(collection)
            .whereField("schemaVersion", isLessThan: getTargetSchemaVersion(for: collection))
            .limit(to: 1)
            .getDocuments()
        
        return documents.documents.isEmpty
    }
} 