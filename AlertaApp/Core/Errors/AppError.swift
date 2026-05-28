import Foundation

enum AppError: Error, Equatable {
    case unavailableFeature(name: String)
    case hapticEngineCreationFails(String)
    case hapticEngineStartFails(String)
    case hapticPlaybackFails(String)

    var message: String {
        switch self {
        case let .unavailableFeature(name):
            "\(name) is not available in this build."
        case let .hapticEngineCreationFails(errorMsg):
            "Failed to create haptic engine: \(errorMsg)"
        case let .hapticEngineStartFails(errorMsg):
            "Failed to start haptic engine: \(errorMsg)"
        case let .hapticPlaybackFails(errorMsg):
            "Failed to play haptic pattern: \(errorMsg)"
        }
    }
}
