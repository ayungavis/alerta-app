import Foundation

enum DetectionUrgency: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
}

struct DetectionCandidate {
    let identifier: String
    let confidence: Float
}

struct DetectionEvent: Identifiable {
    let id: UUID
    let soundEvent: SoundEvent
    let direction: SoundDirection
    let confidence: Float
    let urgency: DetectionUrgency
    let topCandidates: [DetectionCandidate]
    let rawIdentifier: String
    let timestamp: Date
    let frequencyInfo: FrequencySpectrum?
    let soundName: String?
}
