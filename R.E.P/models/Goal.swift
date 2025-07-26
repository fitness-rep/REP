import Foundation
import FirebaseFirestore

struct Goal: Codable, Identifiable {
    var id: String { goalId }
    let goalId: String
    let userId: String?
    let type: String // e.g., "weight_loss", "weight_gain", "stay_fit"
    let description: String
    let targetValue: Double?
    let targetUnit: String // e.g., "lbs", "kg", "range"
    let targetRange: [String: Double]? // ["min": 150, "max": 160] for stay fit
    let durationWeeks: Int
    let targetPerWeek: Double?
    let startDate: Date
    let endDate: Date
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    var progress: Double
    let routineId: String?
    var schemaVersion: Int = 1

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "goalId": goalId,
            "userId": userId as Any,
            "type": type,
            "description": description,
            "targetValue": targetValue as Any,
            "targetUnit": targetUnit,
            "targetRange": targetRange as Any,
            "durationWeeks": durationWeeks,
            "targetPerWeek": targetPerWeek as Any,
            "startDate": Timestamp(date: startDate),
            "endDate": Timestamp(date: endDate),
            "isActive": isActive,
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt),
            "progress": progress,
            "routineId": routineId as Any,
            "schemaVersion": schemaVersion
        ]
        return dict
    }

    static func fromDictionary(_ data: [String: Any]) -> Goal? {
        guard let goalId = data["goalId"] as? String,
              let type = data["type"] as? String,
              let description = data["description"] as? String,
              let durationWeeks = data["durationWeeks"] as? Int,
              let targetUnit = data["targetUnit"] as? String,
              let startDateRaw = data["startDate"],
              let endDateRaw = data["endDate"],
              let isActive = data["isActive"] as? Bool,
              let createdAtRaw = data["createdAt"],
              let updatedAtRaw = data["updatedAt"],
              let progress = data["progress"] as? Double else { return nil }
        let userId = data["userId"] as? String
        let targetValue = data["targetValue"] as? Double
        let targetRange = data["targetRange"] as? [String: Double]
        let targetPerWeek = data["targetPerWeek"] as? Double
        let routineId = data["routineId"] as? String
        let schemaVersion = data["schemaVersion"] as? Int ?? 1
        let startDate = (startDateRaw as? Timestamp)?.dateValue() ?? (startDateRaw as? Date) ?? Date()
        let endDate = (endDateRaw as? Timestamp)?.dateValue() ?? (endDateRaw as? Date) ?? Date()
        let createdAt = (createdAtRaw as? Timestamp)?.dateValue() ?? (createdAtRaw as? Date) ?? Date()
        let updatedAt = (updatedAtRaw as? Timestamp)?.dateValue() ?? (updatedAtRaw as? Date) ?? Date()
        return Goal(
            goalId: goalId,
            userId: userId,
            type: type,
            description: description,
            targetValue: targetValue,
            targetUnit: targetUnit,
            targetRange: targetRange,
            durationWeeks: durationWeeks,
            targetPerWeek: targetPerWeek,
            startDate: startDate,
            endDate: endDate,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            progress: progress,
            routineId: routineId,
            schemaVersion: schemaVersion
        )
    }
} 