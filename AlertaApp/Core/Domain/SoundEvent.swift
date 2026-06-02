import Foundation

enum SoundEvent: String, CaseIterable, Identifiable {
    case approachingVehicle = "Approaching vehicle"
    case bicycleOrScooter = "Bicycle or scooter"
    case horn = "Horn"
    case siren = "Siren"
    case nearbyPersonMovement = "Nearby movement"
    case generalLoudSound = "General loud sound"

    var id: String {
        rawValue
    }

    var urgency: DetectionUrgency {
        switch self {
        case .siren: .critical
        case .horn, .approachingVehicle: .high
        case .bicycleOrScooter, .generalLoudSound: .medium
        case .nearbyPersonMovement: .low
        }
    }
}

enum SoundDirection: String {
    case frontLeft = "Front Left"
    case frontRight = "Front Right"
    case backLeft = "Back Left"
    case backRight = "Back Right"
    case left = "Left"
    case right = "Right"
    case nearby = "Nearby"
    case unknown = "Unknown"
}
