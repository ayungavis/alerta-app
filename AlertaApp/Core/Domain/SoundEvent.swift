import Foundation

enum SoundEvent: String, CaseIterable, Identifiable {
    case approachingVehicle = "Approaching vehicle"
    case bicycleOrScooter = "Bicycle or scooter"
    case horn = "Horn"
    case siren = "Siren"
    case nearbyPersonMovement = "Nearby movement"
    case generalLoudSound = "General loud sound"

    var id: String { rawValue }

    var urgency: DetectionUrgency {
        switch self {
        case .siren: return .critical
        case .horn, .approachingVehicle: return .high
        case .bicycleOrScooter, .generalLoudSound: return .medium
        case .nearbyPersonMovement: return .low
        }
    }
}

enum SoundDirection: String {
    case left = "Left"
    case right = "Right"
    case nearby = "Nearby"
    case unknown = "Unknown"
}
