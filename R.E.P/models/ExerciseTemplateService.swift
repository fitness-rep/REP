//
//  ExerciseTemplateService.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//

import Foundation
import FirebaseFirestore

class ExerciseTemplateService: ObservableObject {
    static let shared = ExerciseTemplateService()
    private let firestoreService = FirestoreService.shared
    
    @Published var templates: [ExerciseTemplate] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Cache for templates to avoid repeated fetches
    private var templateCache: [String: ExerciseTemplate] = [:]
    
    private init() {}
    
    // MARK: - Template Management
    
    func loadTemplates(type: ExerciseType? = nil) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedTemplates = try await firestoreService.getExerciseTemplates(type: type)
            
            await MainActor.run {
                self.templates = fetchedTemplates
                // Update cache
                for template in fetchedTemplates {
                    self.templateCache[template.templateId] = template
                }
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func getTemplate(id: String) async -> ExerciseTemplate? {
        // Check cache first
        if let cachedTemplate = templateCache[id] {
            return cachedTemplate
        }
        
        // Fetch from Firestore if not in cache
        do {
            let template = try await firestoreService.getExerciseTemplate(id: id)
            if let template = template {
                templateCache[id] = template
            }
            return template
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
            return nil
        }
    }
    
    func createTemplate(_ template: ExerciseTemplate) async throws {
        try await firestoreService.createExerciseTemplate(template)
        
        // Update local cache and templates
        await MainActor.run {
            self.templateCache[template.templateId] = template
            if !self.templates.contains(where: { $0.templateId == template.templateId }) {
                self.templates.append(template)
            }
        }
    }
    
    func updateTemplate(_ template: ExerciseTemplate) async throws {
        try await firestoreService.updateExerciseTemplate(template)
        
        // Update local cache and templates
        await MainActor.run {
            self.templateCache[template.templateId] = template
            if let index = self.templates.firstIndex(where: { $0.templateId == template.templateId }) {
                self.templates[index] = template
            }
        }
    }
    
    func deleteTemplate(id: String) async throws {
        try await firestoreService.deleteExerciseTemplate(id: id)
        
        // Remove from local cache and templates
        await MainActor.run {
            self.templateCache.removeValue(forKey: id)
            self.templates.removeAll { $0.templateId == id }
        }
    }
    
    // MARK: - Exercise Plan Helpers
    
    func getExercisePlanWithTemplates(_ plan: ExercisePlan) async -> ExercisePlan {
        do {
            return try await firestoreService.getExercisePlanWithTemplates(plan)
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
            return plan
        }
    }
    
    func getExerciseWithTemplate(_ exercise: Exercise) async -> Exercise {
        do {
            return try await firestoreService.getExerciseWithTemplate(exercise)
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
            return exercise
        }
    }
    
    // MARK: - Convenience Methods
    
    func getTemplatesByType(_ type: ExerciseType) -> [ExerciseTemplate] {
        return templates.filter { $0.type == type && $0.isActive }
    }
    
    func getTemplatesByMuscleGroup(_ muscleGroup: String) -> [ExerciseTemplate] {
        return templates.filter { template in
            template.isActive && template.muscleGroups?.contains(muscleGroup) == true
        }
    }
    
    func searchTemplates(query: String) -> [ExerciseTemplate] {
        let lowercasedQuery = query.lowercased()
        return templates.filter { template in
            template.isActive && (
                template.name.lowercased().contains(lowercasedQuery) ||
                template.description?.lowercased().contains(lowercasedQuery) == true
            )
        }
    }
    

} 