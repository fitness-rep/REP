//
//  FirestoreService.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//

import Foundation
import FirebaseFirestore

class FirestoreService: ObservableObject {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - User Operations
    
    func createUser(_ user: User) async throws {
        let userData = user.toDictionary()
        try await db.collection("users").document(user.uid).setData(userData)
    }
    
    func getUser(uid: String) async throws -> User? {
        let document = try await db.collection("users").document(uid).getDocument()
        guard let data = document.data() else { return nil }
        return User.fromDictionary(data)
    }
    
    func updateUser(_ user: User) async throws {
        let userData = user.toDictionary()
        try await db.collection("users").document(user.uid).setData(userData, merge: true)
    }
    
    func updateUserCurrentRoutine(uid: String, routineId: String?) async throws {
        try await db.collection("users").document(uid).updateData([
            "currentRoutineId": routineId as Any
        ])
    }
    
    func updateUserGoal(uid: String, goalId: String?) async throws {
        try await db.collection("users").document(uid).updateData([
            "goalId": goalId as Any
        ])
    }
    
    func updateUserGoals(uid: String, goals: [Goal]) async throws {
        let goalsData = goals.map { $0.toDictionary() }
        try await db.collection("users").document(uid).updateData([
            "goals": goalsData
        ])
    }
    
    // MARK: - Exercise Plan Operations
    
    func createExercisePlan(_ plan: ExercisePlan) async throws {
        let planData = plan.toDictionary()
        try await db.collection("exercisePlans").document(plan.documentId).setData(planData)
    }
    
    func getExercisePlan(id: String) async throws -> ExercisePlan? {
        let document = try await db.collection("exercisePlans").document(id).getDocument()
        guard let data = document.data() else { return nil }
        return ExercisePlan.fromDictionary(data)
    }
    
    func getExercisePlans(createdBy: String? = nil) async throws -> [ExercisePlan] {
        var query: Query = db.collection("exercisePlans")
        
        if let createdBy = createdBy {
            query = query.whereField("createdBy", isEqualTo: createdBy)
        }
        
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { document in
            ExercisePlan.fromDictionary(document.data())
        }
    }
    
    func updateExercisePlan(_ plan: ExercisePlan) async throws {
        let planData = plan.toDictionary()
        try await db.collection("exercisePlans").document(plan.documentId).setData(planData, merge: true)
    }
    
    func deleteExercisePlan(id: String) async throws {
        try await db.collection("exercisePlans").document(id).delete()
    }
    
    // MARK: - Exercise Template Operations
    
    func createExerciseTemplate(_ template: ExerciseTemplate) async throws {
        let templateData = template.toDictionary()
        try await db.collection("exerciseTemplates").document(template.templateId).setData(templateData)
    }
    
    func getExerciseTemplate(id: String) async throws -> ExerciseTemplate? {
        let document = try await db.collection("exerciseTemplates").document(id).getDocument()
        guard let data = document.data() else { return nil }
        return ExerciseTemplate.fromDictionary(data)
    }
    
    func getExerciseTemplates(type: ExerciseType? = nil, isActive: Bool = true) async throws -> [ExerciseTemplate] {
        var query: Query = db.collection("exerciseTemplates").whereField("isActive", isEqualTo: isActive)
        
        if let type = type {
            query = query.whereField("type", isEqualTo: type.rawValue)
        }
        
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { ExerciseTemplate.fromDictionary($0.data()) }
    }
    
    func updateExerciseTemplate(_ template: ExerciseTemplate) async throws {
        let templateData = template.toDictionary()
        try await db.collection("exerciseTemplates").document(template.templateId).setData(templateData, merge: true)
    }
    
    func deleteExerciseTemplate(id: String) async throws {
        try await db.collection("exerciseTemplates").document(id).delete()
    }
    
    // Helper function to fetch template for an exercise
    func getExerciseWithTemplate(_ exercise: Exercise) async throws -> Exercise {
        var updatedExercise = exercise
        updatedExercise.template = try await getExerciseTemplate(id: exercise.templateId)
        return updatedExercise
    }
    
    // Helper function to fetch templates for all exercises in a plan
    func getExercisePlanWithTemplates(_ plan: ExercisePlan) async throws -> ExercisePlan {
        let exercisesWithTemplates = try await withThrowingTaskGroup(of: Exercise.self) { group in
            for exercise in plan.exercises {
                group.addTask {
                    return try await self.getExerciseWithTemplate(exercise)
                }
            }
            
            var results: [Exercise] = []
            for try await exercise in group {
                results.append(exercise)
            }
            return results.sorted { $0.templateId < $1.templateId }
        }
        
        return ExercisePlan(
            documentId: plan.documentId,
            createdBy: plan.createdBy,
            description: plan.description,
            exercises: exercisesWithTemplates
        )
    }
    
    // MARK: - Meal Plan Operations
    
    func createMealPlan(_ plan: MealPlan) async throws {
        let planData = plan.toDictionary()
        try await db.collection("mealPlans").document(plan.documentId).setData(planData)
    }
    
    func getMealPlan(id: String) async throws -> MealPlan? {
        let document = try await db.collection("mealPlans").document(id).getDocument()
        guard let data = document.data() else { return nil }
        return MealPlan.fromDictionary(data)
    }
    
    func getMealPlans(createdBy: String? = nil) async throws -> [MealPlan] {
        var query: Query = db.collection("mealPlans")
        
        if let createdBy = createdBy {
            query = query.whereField("createdBy", isEqualTo: createdBy)
        }
        
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { document in
            MealPlan.fromDictionary(document.data())
        }
    }
    
    func updateMealPlan(_ plan: MealPlan) async throws {
        let planData = plan.toDictionary()
        try await db.collection("mealPlans").document(plan.documentId).setData(planData, merge: true)
    }
    
    func deleteMealPlan(id: String) async throws {
        try await db.collection("mealPlans").document(id).delete()
    }
    
    // MARK: - Food Operations
    
    func createFood(_ food: Food) async throws {
        let foodData = food.toDictionary()
        try await db.collection("foods").document(food.documentId).setData(foodData)
    }
    
    func getFood(id: String) async throws -> Food? {
        let document = try await db.collection("foods").document(id).getDocument()
        guard let data = document.data() else { return nil }
        return Food.fromDictionary(data)
    }
    
    func getFoods(category: FoodCategory? = nil, searchTerm: String? = nil) async throws -> [Food] {
        var query: Query = db.collection("foods")
        
        if let category = category {
            query = query.whereField("category", isEqualTo: category.rawValue)
        }
        
        if let searchTerm = searchTerm, !searchTerm.isEmpty {
            query = query.whereField("name", isGreaterThanOrEqualTo: searchTerm)
                .whereField("name", isLessThan: searchTerm + "\u{f8ff}")
        }
        
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { document in
            Food.fromDictionary(document.data())
        }
    }
    
    func updateFood(_ food: Food) async throws {
        let foodData = food.toDictionary()
        try await db.collection("foods").document(food.documentId).setData(foodData, merge: true)
    }
    
    func deleteFood(id: String) async throws {
        try await db.collection("foods").document(id).delete()
    }
    
    // MARK: - Routine Operations
    
    func createRoutine(_ routine: Routine) async throws {
        let routineData = routine.toDictionary()
        try await db.collection("routines").document(routine.documentId).setData(routineData)
    }
    
    func getRoutine(id: String) async throws -> Routine? {
        let document = try await db.collection("routines").document(id).getDocument()
        guard let data = document.data() else { return nil }
        return Routine.fromDictionary(data)
    }
    
    func getUserRoutines(userId: String) async throws -> [Routine] {
        let snapshot = try await db.collection("routines")
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            Routine.fromDictionary(document.data())
        }
    }
    
    func getActiveRoutine(userId: String) async throws -> Routine? {
        let snapshot = try await db.collection("routines")
            .whereField("userId", isEqualTo: userId)
            .whereField("isActive", isEqualTo: true)
            .limit(to: 1)
            .getDocuments()
        
        return snapshot.documents.first.flatMap { document in
            Routine.fromDictionary(document.data())
        }
    }
    
    func updateRoutine(_ routine: Routine) async throws {
        let routineData = routine.toDictionary()
        try await db.collection("routines").document(routine.documentId).setData(routineData, merge: true)
    }
    
    func updateRoutineProgress(id: String, progress: RoutineProgress) async throws {
        try await db.collection("routines").document(id).updateData([
            "progress": progress.toDictionary()
        ])
    }
    
    func updateRoutineCurrentDay(id: String, currentDay: Int) async throws {
        try await db.collection("routines").document(id).updateData([
            "currentDay": currentDay
        ])
    }
    
    func deleteRoutine(id: String) async throws {
        try await db.collection("routines").document(id).delete()
    }
    
    // MARK: - Goal Operations
    func createGoal(_ goal: Goal) async throws {
        let goalData = goal.toDictionary()
        try await db.collection("goals").document(goal.goalId).setData(goalData)
    }
    func getGoal(id: String) async throws -> Goal? {
        let document = try await db.collection("goals").document(id).getDocument()
        guard let data = document.data() else { return nil }
        return Goal.fromDictionary(data)
    }
    func getUserGoals(userId: String) async throws -> [Goal] {
        let snapshot = try await db.collection("goals").whereField("userId", isEqualTo: userId).getDocuments()
        return snapshot.documents.compactMap { Goal.fromDictionary($0.data()) }
    }
    func updateGoal(_ goal: Goal) async throws {
        let goalData = goal.toDictionary()
        try await db.collection("goals").document(goal.goalId).setData(goalData, merge: true)
    }
    func deleteGoal(id: String) async throws {
        try await db.collection("goals").document(id).delete()
    }
    // MARK: - Attribute Log Operations
    func createAttributeLog(_ log: AttributeLog) async throws {
        let logData = log.toDictionary()
        try await db.collection("attributeLogs").document(log.logId).setData(logData)
    }
    func getAttributeLog(id: String) async throws -> AttributeLog? {
        let document = try await db.collection("attributeLogs").document(id).getDocument()
        guard let data = document.data() else { return nil }
        return AttributeLog.fromDictionary(data)
    }
    func getUserAttributeLogs(userId: String, goalId: String? = nil) async throws -> [AttributeLog] {
        var query: Query = db.collection("attributeLogs").whereField("userId", isEqualTo: userId)
        if let goalId = goalId {
            query = query.whereField("goalId", isEqualTo: goalId)
        }
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { AttributeLog.fromDictionary($0.data()) }
    }
    func updateAttributeLog(_ log: AttributeLog) async throws {
        let logData = log.toDictionary()
        try await db.collection("attributeLogs").document(log.logId).setData(logData, merge: true)
    }
    func deleteAttributeLog(id: String) async throws {
        try await db.collection("attributeLogs").document(id).delete()
    }
    // MARK: - Activity Log Operations (updated)
    func createActivityLog(_ log: ActivityLog) async throws {
        let logData = log.toDictionary()
        try await db.collection("activityLogs").document(log.documentId).setData(logData)
    }
    func getActivityLog(id: String) async throws -> ActivityLog? {
        let document = try await db.collection("activityLogs").document(id).getDocument()
        guard let data = document.data() else { return nil }
        return ActivityLog.fromDictionary(data)
    }
    func getUserActivityLogs(userId: String, goalId: String? = nil, routineId: String? = nil) async throws -> [ActivityLog] {
        var query: Query = db.collection("activityLogs").whereField("userId", isEqualTo: userId)
        if let goalId = goalId {
            query = query.whereField("goalId", isEqualTo: goalId)
        }
        if let routineId = routineId {
            query = query.whereField("routineId", isEqualTo: routineId)
        }
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { ActivityLog.fromDictionary($0.data()) }
    }
    func updateActivityLog(_ log: ActivityLog) async throws {
        let logData = log.toDictionary()
        try await db.collection("activityLogs").document(log.documentId).setData(logData, merge: true)
    }
    func deleteActivityLog(id: String) async throws {
        try await db.collection("activityLogs").document(id).delete()
    }
    
    // MARK: - Daily Progress Operations
    
    func createDailyProgress(_ progress: DailyProgress) async throws {
        let progressData = progress.toDictionary()
        try await db.collection("dailyProgress").document(progress.documentId).setData(progressData)
    }
    
    func getDailyProgress(id: String) async throws -> DailyProgress? {
        let document = try await db.collection("dailyProgress").document(id).getDocument()
        guard let data = document.data() else { return nil }
        return DailyProgress.fromDictionary(data)
    }
    
    func getUserDailyProgress(userId: String, date: Date) async throws -> DailyProgress? {
        let dateString = DailyProgress.dateFormatter.string(from: date)
        let snapshot = try await db.collection("dailyProgress")
            .whereField("userId", isEqualTo: userId)
            .whereField("date", isEqualTo: dateString)
            .limit(to: 1)
            .getDocuments()
        
        return snapshot.documents.first.flatMap { document in
            DailyProgress.fromDictionary(document.data())
        }
    }
    
    func updateDailyProgress(_ progress: DailyProgress) async throws {
        let progressData = progress.toDictionary()
        try await db.collection("dailyProgress").document(progress.documentId).setData(progressData, merge: true)
    }
    
    func deleteDailyProgress(id: String) async throws {
        try await db.collection("dailyProgress").document(id).delete()
    }
    

}

// MARK: - Supporting Types

struct UserStats {
    let totalCalories: Double
    let totalExercises: Int
    let totalMeals: Int
    let averageGoalProgress: Double
}

extension FirestoreService {
    // Fetch user stats for a date range
    func getUserStats(userId: String, startDate: Date, endDate: Date) async throws -> UserStats {
        // Query dailyProgress documents for the user in the date range
        let snapshot = try await db.collection("dailyProgress")
            .whereField("userId", isEqualTo: userId)
            .whereField("date", isGreaterThanOrEqualTo: DailyProgress.dateFormatter.string(from: startDate))
            .whereField("date", isLessThanOrEqualTo: DailyProgress.dateFormatter.string(from: endDate))
            .getDocuments()
        
        let dailyProgresses = snapshot.documents.compactMap { DailyProgress.fromDictionary($0.data()) }
        
        let totalCalories = dailyProgresses.reduce(0) { $0 + $1.caloriesConsumed }
        let totalExercises = dailyProgresses.reduce(0) { $0 + ($1.workoutMinutesCompleted > 0 ? 1 : 0) } // Count days with workouts
        let totalMeals = dailyProgresses.reduce(0) { $0 + ($1.caloriesConsumed > 0 ? 1 : 0) } // Count days with meals
        let averageGoalProgress = dailyProgresses.isEmpty ? 0 : dailyProgresses.reduce(0) { $0 + (($1.caloriesProgress + $1.workoutProgress) / 2.0) } / Double(dailyProgresses.count)
        
        return UserStats(
            totalCalories: totalCalories,
            totalExercises: totalExercises,
            totalMeals: totalMeals,
            averageGoalProgress: averageGoalProgress
        )
    }
} 

