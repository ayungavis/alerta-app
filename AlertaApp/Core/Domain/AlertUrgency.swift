import Foundation

enum AlertUrgency {
    case low
    case medium
    case high
    case critical
}

struct DetectionEvent {
    let urgency: AlertUrgency
    let soundName: String
}
