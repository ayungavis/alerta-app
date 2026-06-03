import Foundation
import Observation

struct CustomPattern: Identifiable {
    let id = UUID()
    let name: String
    let steps: [HapticRecorderManager.RecordedStep]
}

@Observable
@MainActor
final class HapticsSettingsViewModel {
    var selections: [Urgency: String] = [
        .low: "Steady Alert",
        .medium: "Rapid Pulse",
        .high: "Heartbeat",
        .critical: "S.O.S."
    ]

    let availablePatterns: [String] = [
        "Steady Alert",
        "Rapid Pulse",
        "Heartbeat",
        "S.O.S.",
        "Staccato"
    ]

    var customPatterns: [CustomPattern] = []
    func selectPattern(_ pattern: String, for level: Urgency) {
        selections[level] = pattern
    }
}
