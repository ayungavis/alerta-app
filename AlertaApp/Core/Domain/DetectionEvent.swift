import Foundation

struct DetectionCandidate {
    let identifier: String
    let confidence: Float
}

struct DetectionEvent: Identifiable {
    let id: UUID
    let soundEvent: SoundEvent
    let direction: SoundDirection
    let confidence: Float
    let urgency: Urgency
    let topCandidates: [DetectionCandidate]
    let rawIdentifier: String
    let timestamp: Date
    let frequencyInfo: FrequencySpectrum?
    let soundName: String?
}
