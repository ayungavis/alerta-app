import Foundation

/// Unified error type for the application.
/// Add new top-level cases per subsystem; nest detail via associated enums.
enum AppError: Error {
    case unavailableFeature(UnavailableFeatureError)
    case audioOutput(AudioOutputError)
    case hapticEngineCreationFails(String)
    case hapticEngineStartFails(String)
    case hapticPlaybackFails(String)

    enum UnavailableFeatureError {
        /// A requested feature is not available in this build (e.g. missing entitlement, unsupported OS version).
        case unavailableFeature(name: String)
        case hapticEngineCreationFails(String)
        case hapticEngineStartFails(String)
        case hapticPlaybackFails(String)
        case microphoneUnavailable
        case invalidInputFormat
        case permissionDenied
        case sessionInterrupted
        case audioEngineFailed(message: String)
    }

    enum AudioOutputError {
        /// The `AVAudioSession` could not be activated (e.g. interrupted by a call).
        case sessionActivationFailed(underlying: Error)
        /// The requested system sound ID is not available on this OS version.
        case systemSoundUnavailable(id: UInt32)
        /// The speech synthesiser rejected the utterance (empty string, bad locale, etc.).
        case utteranceRejected(reason: String)
    }
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .unavailableFeature(e):
            e.localizedDescription
        case let .audioOutput(e):
            e.localizedDescription
        case let .hapticEngineCreationFails(message):
            message
        case let .hapticEngineStartFails(message):
            message
        case let .hapticPlaybackFails(message):
            message
        }
    }
}

extension AppError.UnavailableFeatureError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .unavailableFeature(name):
            "\(name) is not available in this build."
        case let .hapticEngineCreationFails(errorMsg):
            "Failed to create haptic engine: \(errorMsg)"
        case let .hapticEngineStartFails(errorMsg):
            "Failed to start haptic engine: \(errorMsg)"
        case let .hapticPlaybackFails(errorMsg):
            "Failed to play haptic pattern: \(errorMsg)"
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

extension AppError.AudioOutputError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .sessionActivationFailed(e):
            "Audio session activation failed: \(e.localizedDescription)"
        case let .systemSoundUnavailable(id):
            "System sound \(id) is unavailable on this device."
        case let .utteranceRejected(reason):
            "Speech utterance rejected: \(reason)"
        }
    }
}
