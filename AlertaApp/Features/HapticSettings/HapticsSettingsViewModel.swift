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
    var selectedPattern: String = "Rapid Pulse"

    let availablePatterns: [String] = [
        "Steady Alert",
        "Rapid Pulse",
        "Heartbeat",
        "Emergency"
    ]

    var customPatterns: [CustomPattern] = []

    func selectPattern(_ pattern: String) {
        selectedPattern = pattern
    }
}
