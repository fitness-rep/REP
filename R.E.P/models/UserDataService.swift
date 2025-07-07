//
//  UserDataService.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//

import Foundation
import FirebaseAuth

class UserDataService: ObservableObject {
    static let shared = UserDataService()
    private let firestoreService = FirestoreService.shared
    private let authManager = FirebaseAuthManager.shared
    
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {}
    
    // MARK: - User Registration
    
    func registerUser(email: String, password: String, registrationUser: RegistrationUser) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authManager.signUp(email: email, password: password, registrationUser: registrationUser)
            
            // Fetch the created user data
            if let authUser = authManager.currentUser {
                currentUser = try await firestoreService.getUser(uid: authUser.uid)
            }
            
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            throw error
        }
    }
    
    // MARK: - User Authentication
    
    func signIn(email: String, password: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authManager.signIn(email: email, password: password)
            
            // Fetch user data from Firestore
            if let authUser = authManager.currentUser {
                currentUser = try await firestoreService.getUser(uid: authUser.uid)
            }
            
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            throw error
        }
    }
    
    func signOut() {
        do {
            try authManager.signOut()
            currentUser = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - User Data Management
    
    func updateUserProfile(name: String? = nil, age: Double? = nil, height: Double? = nil, weight: Double? = nil, fitnessGoal: String? = nil) async throws {
        guard let currentUser = currentUser else { return }
        
        var updatedUser = currentUser
        
        if let name = name {
            updatedUser = User(
                uid: currentUser.uid,
                name: name,
                email: currentUser.email,
                gender: currentUser.gender,
                age: currentUser.age,
                height: currentUser.height,
                weight: currentUser.weight,
                fitnessGoal: currentUser.fitnessGoal,
                strengthExperience: currentUser.strengthExperience,
                experienceLevel: currentUser.experienceLevel,
                gymChallenge: currentUser.gymChallenge,
                strengthRoutine: currentUser.strengthRoutine,
                exerciseLocation: currentUser.exerciseLocation,
                workoutDuration: currentUser.workoutDuration,
                trainingWindowStart: currentUser.trainingWindowStart,
                trainingWindowEnd: currentUser.trainingWindowEnd,
                foodPreference: currentUser.foodPreference,
                isTakingMedications: currentUser.isTakingMedications,
                medications: currentUser.medications,
                hasInjuries: currentUser.hasInjuries,
                injuries: currentUser.injuries,
                targetWeight: currentUser.targetWeight,
                targetWeightUnit: currentUser.targetWeightUnit,
                trainingFocusAreas: currentUser.trainingFocusAreas,
                scheduleType: currentUser.scheduleType,
                smartScheduleWorkoutsPerWeek: currentUser.smartScheduleWorkoutsPerWeek,
                fixedScheduleDays: currentUser.fixedScheduleDays,
                heightUnit: currentUser.heightUnit,
                weightUnit: currentUser.weightUnit,
                registrationDate: currentUser.registrationDate,
                currentRoutineId: currentUser.currentRoutineId,
                goals: currentUser.goals,
                schemaVersion: currentUser.schemaVersion
            )
        }
        
        if let age = age {
            updatedUser = User(
                uid: currentUser.uid,
                name: updatedUser.name,
                email: currentUser.email,
                gender: currentUser.gender,
                age: age,
                height: currentUser.height,
                weight: currentUser.weight,
                fitnessGoal: currentUser.fitnessGoal,
                strengthExperience: currentUser.strengthExperience,
                experienceLevel: currentUser.experienceLevel,
                gymChallenge: currentUser.gymChallenge,
                strengthRoutine: currentUser.strengthRoutine,
                exerciseLocation: currentUser.exerciseLocation,
                workoutDuration: currentUser.workoutDuration,
                trainingWindowStart: currentUser.trainingWindowStart,
                trainingWindowEnd: currentUser.trainingWindowEnd,
                foodPreference: currentUser.foodPreference,
                isTakingMedications: currentUser.isTakingMedications,
                medications: currentUser.medications,
                hasInjuries: currentUser.hasInjuries,
                injuries: currentUser.injuries,
                targetWeight: currentUser.targetWeight,
                targetWeightUnit: currentUser.targetWeightUnit,
                trainingFocusAreas: currentUser.trainingFocusAreas,
                scheduleType: currentUser.scheduleType,
                smartScheduleWorkoutsPerWeek: currentUser.smartScheduleWorkoutsPerWeek,
                fixedScheduleDays: currentUser.fixedScheduleDays,
                heightUnit: currentUser.heightUnit,
                weightUnit: currentUser.weightUnit,
                registrationDate: currentUser.registrationDate,
                currentRoutineId: currentUser.currentRoutineId,
                goals: currentUser.goals,
                schemaVersion: currentUser.schemaVersion
            )
        }
        
        if let height = height {
            updatedUser = User(
                uid: currentUser.uid,
                name: updatedUser.name,
                email: currentUser.email,
                gender: currentUser.gender,
                age: updatedUser.age,
                height: height,
                weight: currentUser.weight,
                fitnessGoal: currentUser.fitnessGoal,
                strengthExperience: currentUser.strengthExperience,
                experienceLevel: currentUser.experienceLevel,
                gymChallenge: currentUser.gymChallenge,
                strengthRoutine: currentUser.strengthRoutine,
                exerciseLocation: currentUser.exerciseLocation,
                workoutDuration: currentUser.workoutDuration,
                trainingWindowStart: currentUser.trainingWindowStart,
                trainingWindowEnd: currentUser.trainingWindowEnd,
                foodPreference: currentUser.foodPreference,
                isTakingMedications: currentUser.isTakingMedications,
                medications: currentUser.medications,
                hasInjuries: currentUser.hasInjuries,
                injuries: currentUser.injuries,
                targetWeight: currentUser.targetWeight,
                targetWeightUnit: currentUser.targetWeightUnit,
                trainingFocusAreas: currentUser.trainingFocusAreas,
                scheduleType: currentUser.scheduleType,
                smartScheduleWorkoutsPerWeek: currentUser.smartScheduleWorkoutsPerWeek,
                fixedScheduleDays: currentUser.fixedScheduleDays,
                heightUnit: currentUser.heightUnit,
                weightUnit: currentUser.weightUnit,
                registrationDate: currentUser.registrationDate,
                currentRoutineId: currentUser.currentRoutineId,
                goals: currentUser.goals,
                schemaVersion: currentUser.schemaVersion
            )
        }
        
        if let weight = weight {
            updatedUser = User(
                uid: currentUser.uid,
                name: updatedUser.name,
                email: currentUser.email,
                gender: currentUser.gender,
                age: updatedUser.age,
                height: updatedUser.height,
                weight: weight,
                fitnessGoal: currentUser.fitnessGoal,
                strengthExperience: currentUser.strengthExperience,
                experienceLevel: currentUser.experienceLevel,
                gymChallenge: currentUser.gymChallenge,
                strengthRoutine: currentUser.strengthRoutine,
                exerciseLocation: currentUser.exerciseLocation,
                workoutDuration: currentUser.workoutDuration,
                trainingWindowStart: currentUser.trainingWindowStart,
                trainingWindowEnd: currentUser.trainingWindowEnd,
                foodPreference: currentUser.foodPreference,
                isTakingMedications: currentUser.isTakingMedications,
                medications: currentUser.medications,
                hasInjuries: currentUser.hasInjuries,
                injuries: currentUser.injuries,
                targetWeight: currentUser.targetWeight,
                targetWeightUnit: currentUser.targetWeightUnit,
                trainingFocusAreas: currentUser.trainingFocusAreas,
                scheduleType: currentUser.scheduleType,
                smartScheduleWorkoutsPerWeek: currentUser.smartScheduleWorkoutsPerWeek,
                fixedScheduleDays: currentUser.fixedScheduleDays,
                heightUnit: currentUser.heightUnit,
                weightUnit: currentUser.weightUnit,
                registrationDate: currentUser.registrationDate,
                currentRoutineId: currentUser.currentRoutineId,
                goals: currentUser.goals,
                schemaVersion: currentUser.schemaVersion
            )
        }
        
        if let fitnessGoal = fitnessGoal {
            updatedUser = User(
                uid: currentUser.uid,
                name: updatedUser.name,
                email: currentUser.email,
                gender: currentUser.gender,
                age: updatedUser.age,
                height: updatedUser.height,
                weight: updatedUser.weight,
                fitnessGoal: fitnessGoal,
                strengthExperience: currentUser.strengthExperience,
                experienceLevel: currentUser.experienceLevel,
                gymChallenge: currentUser.gymChallenge,
                strengthRoutine: currentUser.strengthRoutine,
                exerciseLocation: currentUser.exerciseLocation,
                workoutDuration: currentUser.workoutDuration,
                trainingWindowStart: currentUser.trainingWindowStart,
                trainingWindowEnd: currentUser.trainingWindowEnd,
                foodPreference: currentUser.foodPreference,
                isTakingMedications: currentUser.isTakingMedications,
                medications: currentUser.medications,
                hasInjuries: currentUser.hasInjuries,
                injuries: currentUser.injuries,
                targetWeight: currentUser.targetWeight,
                targetWeightUnit: currentUser.targetWeightUnit,
                trainingFocusAreas: currentUser.trainingFocusAreas,
                scheduleType: currentUser.scheduleType,
                smartScheduleWorkoutsPerWeek: currentUser.smartScheduleWorkoutsPerWeek,
                fixedScheduleDays: currentUser.fixedScheduleDays,
                heightUnit: currentUser.heightUnit,
                weightUnit: currentUser.weightUnit,
                registrationDate: currentUser.registrationDate,
                currentRoutineId: currentUser.currentRoutineId,
                goals: currentUser.goals,
                schemaVersion: currentUser.schemaVersion
            )
        }
        
        try await firestoreService.updateUser(updatedUser)
        self.currentUser = updatedUser
    }
    
    func updateUserCurrentRoutine(routineId: String?) async throws {
        guard let currentUser = currentUser else { return }
        
        try await firestoreService.updateUserCurrentRoutine(uid: currentUser.uid, routineId: routineId)
        
        // Update local user data
        let updatedUser = User(
            uid: currentUser.uid,
            name: currentUser.name,
            email: currentUser.email,
            gender: currentUser.gender,
            age: currentUser.age,
            height: currentUser.height,
            weight: currentUser.weight,
            fitnessGoal: currentUser.fitnessGoal,
            strengthExperience: currentUser.strengthExperience,
            experienceLevel: currentUser.experienceLevel,
            gymChallenge: currentUser.gymChallenge,
            strengthRoutine: currentUser.strengthRoutine,
            exerciseLocation: currentUser.exerciseLocation,
            workoutDuration: currentUser.workoutDuration,
            trainingWindowStart: currentUser.trainingWindowStart,
            trainingWindowEnd: currentUser.trainingWindowEnd,
            foodPreference: currentUser.foodPreference,
            isTakingMedications: currentUser.isTakingMedications,
            medications: currentUser.medications,
            hasInjuries: currentUser.hasInjuries,
            injuries: currentUser.injuries,
            targetWeight: currentUser.targetWeight,
            targetWeightUnit: currentUser.targetWeightUnit,
            trainingFocusAreas: currentUser.trainingFocusAreas,
            scheduleType: currentUser.scheduleType,
            smartScheduleWorkoutsPerWeek: currentUser.smartScheduleWorkoutsPerWeek,
            fixedScheduleDays: currentUser.fixedScheduleDays,
            heightUnit: currentUser.heightUnit,
            weightUnit: currentUser.weightUnit,
            registrationDate: currentUser.registrationDate,
            currentRoutineId: routineId,
            goals: currentUser.goals,
            schemaVersion: currentUser.schemaVersion
        )
        
        self.currentUser = updatedUser
    }
    
    func updateUserGoals(goals: [Goal]) async throws {
        guard let currentUser = currentUser else { return }
        
        try await firestoreService.updateUserGoals(uid: currentUser.uid, goals: goals)
        
        // Update local user data
        let updatedUser = User(
            uid: currentUser.uid,
            name: currentUser.name,
            email: currentUser.email,
            gender: currentUser.gender,
            age: currentUser.age,
            height: currentUser.height,
            weight: currentUser.weight,
            fitnessGoal: currentUser.fitnessGoal,
            strengthExperience: currentUser.strengthExperience,
            experienceLevel: currentUser.experienceLevel,
            gymChallenge: currentUser.gymChallenge,
            strengthRoutine: currentUser.strengthRoutine,
            exerciseLocation: currentUser.exerciseLocation,
            workoutDuration: currentUser.workoutDuration,
            trainingWindowStart: currentUser.trainingWindowStart,
            trainingWindowEnd: currentUser.trainingWindowEnd,
            foodPreference: currentUser.foodPreference,
            isTakingMedications: currentUser.isTakingMedications,
            medications: currentUser.medications,
            hasInjuries: currentUser.hasInjuries,
            injuries: currentUser.injuries,
            targetWeight: currentUser.targetWeight,
            targetWeightUnit: currentUser.targetWeightUnit,
            trainingFocusAreas: currentUser.trainingFocusAreas,
            scheduleType: currentUser.scheduleType,
            smartScheduleWorkoutsPerWeek: currentUser.smartScheduleWorkoutsPerWeek,
            fixedScheduleDays: currentUser.fixedScheduleDays,
            heightUnit: currentUser.heightUnit,
            weightUnit: currentUser.weightUnit,
            registrationDate: currentUser.registrationDate,
            currentRoutineId: currentUser.currentRoutineId,
            goals: goals,
            schemaVersion: currentUser.schemaVersion
        )
        
        self.currentUser = updatedUser
    }
    
    // MARK: - User Data Retrieval
    
    func loadCurrentUser() async {
        guard let authUser = authManager.currentUser else { return }
        
        do {
            currentUser = try await firestoreService.getUser(uid: authUser.uid)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - User Statistics
    
    func getUserStats(startDate: Date, endDate: Date) async throws -> UserStats {
        guard let currentUser = currentUser else {
            throw NSError(domain: "UserDataService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user"])
        }
        
        return try await firestoreService.getUserStats(userId: currentUser.uid, startDate: startDate, endDate: endDate)
    }
} 
