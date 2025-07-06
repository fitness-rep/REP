//
//  DailyProgressViewModel.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//

import Foundation
import SwiftUI

class DailyProgressViewModel: ObservableObject {
    @Published var dailyProgress: DailyProgress
    
    init(userId: String, date: Date, userData: RegistrationUser) {
        self.dailyProgress = DailyProgress(userId: userId, date: date, userData: userData)
    }
    
    init(dailyProgress: DailyProgress) {
        self.dailyProgress = dailyProgress
    }
    
    // Computed properties for progress calculations
    var caloriesProgress: Double {
        return dailyProgress.caloriesProgress
    }
    
    var workoutProgress: Double {
        return dailyProgress.workoutProgress
    }
    
    var caloriesRemaining: Double {
        return dailyProgress.caloriesRemaining
    }
    
    var workoutMinutesRemaining: Double {
        return dailyProgress.workoutMinutesRemaining
    }
    
    var caloriesConsumed: Double {
        get { dailyProgress.caloriesConsumed }
        set { 
            dailyProgress = dailyProgress.withUpdatedCalories(newValue)
            objectWillChange.send()
        }
    }
    
    var workoutMinutesCompleted: Double {
        get { dailyProgress.workoutMinutesCompleted }
        set { 
            dailyProgress = dailyProgress.withUpdatedWorkoutMinutes(newValue)
            objectWillChange.send()
        }
    }
    
    var caloriesTarget: Double {
        return dailyProgress.caloriesTarget
    }
    
    var workoutMinutesTarget: Double {
        return dailyProgress.workoutMinutesTarget
    }
    
    var date: Date {
        return dailyProgress.date
    }
    
    // Methods to update progress
    func logCalories(_ calories: Double) {
        dailyProgress = dailyProgress.withAddedCalories(calories)
        objectWillChange.send()
    }
    
    func logWorkout(_ minutes: Double) {
        dailyProgress = dailyProgress.withAddedWorkoutMinutes(minutes)
        objectWillChange.send()
    }
    
    func resetDailyProgress() {
        dailyProgress = dailyProgress.withUpdatedCalories(0.0).withUpdatedWorkoutMinutes(0.0)
        objectWillChange.send()
    }
} 