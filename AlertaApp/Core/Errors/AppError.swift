enum AppError: Error, Equatable {
    case unavailableFeature(name: String)
    case microphoneUnavailable
    case invalidInputFormat
    case permissionDenied
    case sessionInterrupted
    case audioEngineFailed(message: String)

    var message: String {
        switch self {
        case let .unavailableFeature(name):
            "\(name) is not available in this build."
        case let .audioEngineFailed(message):
            "An unexpected error occurred: \(message)."
        case .microphoneUnavailable:
            "Microphone is unavailable."
        case .invalidInputFormat:
            "Invalid input format."
        case .permissionDenied:
            "Permission denied."
        case .sessionInterrupted:
            "Session was interrupted."
        }
    }
}
