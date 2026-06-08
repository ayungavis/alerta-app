import Foundation

enum SoundEvent: String, CaseIterable, Codable, Identifiable {
    case approachingVehicle
    case bicycleOrScooter
    case horn
    case siren
    case nearbyPersonMovement
    case generalLoudSound

    var id: String {
        rawValue
    }

    var displayName: String {
        switch self {
        case .approachingVehicle:
            "Approaching vehicle"
        case .bicycleOrScooter:
            "Bicycle or scooter"
        case .horn:
            "Horn"
        case .siren:
            "Siren"
        case .nearbyPersonMovement:
            "Nearby person movement"
        case .generalLoudSound:
            "General loud sound"
        }
    }

    var urgency: Urgency {
        switch self {
        case .siren: .critical
        case .horn, .approachingVehicle: .high
        case .bicycleOrScooter, .generalLoudSound: .medium
        case .nearbyPersonMovement: .low
        }
    }
}

enum SoundDirection: String, Codable {
    case frontLeft = "Front Left"
    case frontRight = "Front Right"
    case backLeft = "Back Left"
    case backRight = "Back Right"
    case left = "Left"
    case right = "Right"
    case nearby = "Nearby"
    case unknown = "Unknown"
}
