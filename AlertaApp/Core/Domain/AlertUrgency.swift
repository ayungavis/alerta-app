import Foundation

/// Definisi level urgensi sesuai AC tiket
enum AlertUrgency {
    case low
    case medium
    case high
    case critical
}

/// Dummy model untuk DetectionEvent (karena tiket audio CH3-21 masih in-progress)
/// Nanti ini bisa disesuaikan kalau dari tim audio sudah ada model resminya.
struct DetectionEvent {
    let urgency: AlertUrgency
    let soundName: String
}
