//
//  DeviceData.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/5/25.
//
import Foundation

struct DeviceData: Codable, Identifiable {
    var id: String { dataId }
    let dataId: String
    let userId: String
    let deviceType: String // "apple_watch", "whoop", etc.
    let timestamp: Date
    let date: String
    let data: DeviceDataDetails
}

struct DeviceDataDetails: Codable {
    let steps: Int?
    let caloriesBurned: Double?
    let activeMinutes: Int?
    let heartRate: HeartRateData?
    let stressLevel: Int?
    let sleepHours: Double?
    let distance: Double?
    let floors: Int?
}

struct HeartRateData: Codable {
    let average: Int?
    let max: Int?
    let min: Int?
    let resting: Int?
}
