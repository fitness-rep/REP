//
//  DailySummary.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//

struct DailySummary: Codable, Identifiable {
    var id: String { summaryId }
    let summaryId: String
    let userId: String
    let date: String
    let caloriesIn: Double
    let caloriesOut: CaloriesOutSummary
    let steps: Int
    let activeMinutes: Int
    let heartRate: HeartRateData?
    let stressLevel: Int?
    let sleepHours: Double?
    let goalProgress: GoalProgress
}

struct CaloriesOutSummary: Codable {
    let fromWorkouts: Double
    let fromDevice: Double
    let total: Double
}

struct GoalProgress: Codable {
    let calorieDeficit: Double
    let stepGoal: Int
    let stepProgress: Int
    let calorieGoal: Double?
    let calorieProgress: Double?
}
