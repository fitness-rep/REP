import Foundation
import FirebaseFirestore

struct AttributeLog: Codable, Identifiable {
    var id: String { logId }
    let logId: String
    let userId: String
    let goalId: String
    let date: Date
    let attributeType: String // e.g., "weight", "muscle_mass"
    let value: Double
    let unit: String // e.g., "lbs", "kg"
    var schemaVersion: Int = 1

    func toDictionary() -> [String: Any] {
        return [
            "logId": logId,
            "userId": userId,
            "goalId": goalId,
            "date": Timestamp(date: date),
            "attributeType": attributeType,
            "value": value,
            "unit": unit,
            "schemaVersion": schemaVersion
        ]
    }

    static func fromDictionary(_ data: [String: Any]) -> AttributeLog? {
        guard let logId = data["logId"] as? String,
              let userId = data["userId"] as? String,
              let goalId = data["goalId"] as? String,
              let dateRaw = data["date"],
              let attributeType = data["attributeType"] as? String,
              let value = data["value"] as? Double,
              let unit = data["unit"] as? String else { return nil }
        let schemaVersion = data["schemaVersion"] as? Int ?? 1
        let date = (dateRaw as? Timestamp)?.dateValue() ?? (dateRaw as? Date) ?? Date()
        return AttributeLog(
            logId: logId,
            userId: userId,
            goalId: goalId,
            date: date,
            attributeType: attributeType,
            value: value,
            unit: unit,
            schemaVersion: schemaVersion
        )
    }
} 