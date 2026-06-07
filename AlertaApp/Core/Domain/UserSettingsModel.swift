import Foundation
import SwiftData

@Model
final class UserSettingsModel {
    var voiceVolume: Float
    var voiceSpeed: Float
    var hapticSelections: [String: String]
    
    init(
        voiceVolume: Float = 1.0,
        voiceSpeed: Float = 0.5,
        hapticSelections: [String: String] = [
            "low": "Steady Alert",
            "medium": "Rapid Pulse",
            "high": "Heartbeat",
            "critical": "Emergency"
        ]
    ) {
        self.voiceVolume = voiceVolume
        self.voiceSpeed = voiceSpeed
        self.hapticSelections = hapticSelections
    }
}

@Model
final class CustomPatternModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var steps: [RecordedStep]
    
    init(id: UUID = UUID(), name: String, steps: [RecordedStep]) {
        self.id = id
        self.name = name
        self.steps = steps
    }
}

struct RecordedStep: Codable, Hashable {
    var duration: TimeInterval
    var waitTime: TimeInterval
}