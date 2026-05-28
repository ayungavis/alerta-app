import Foundation

enum AppError: Error, Equatable {
    case unavailableFeature(name: String)
    case hapticEngineCreationFails(String)
    case hapticEngineStartFails(String)
    case hapticPlaybackFails(String)

    var message: String {
        switch self {
        case let .unavailableFeature(name):
            return "\(name) is not available in this build."
        case let .hapticEngineCreationFails(errorMsg):
            return "Failed to create haptic engine: \(errorMsg)"
        case let .hapticEngineStartFails(errorMsg):
            return "Failed to start haptic engine: \(errorMsg)"
        case let .hapticPlaybackFails(errorMsg):
            return "Failed to play haptic pattern: \(errorMsg)"
        }
    }
}
