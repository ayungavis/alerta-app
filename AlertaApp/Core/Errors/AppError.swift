import Foundation

/// Unified error type for the application.
/// Add new top-level cases per subsystem; nest detail via associated enums.
enum AppError: Error {
    case unavailableFeature(UnavailableFeatureError)
    case audioOutput(AudioOutputError)

    enum UnavailableFeatureError {
        /// A requested feature is not available in this build (e.g. missing entitlement, unsupported OS version).
        case unavailableFeature(name: String)
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
        case let .unavailableFeature(e): e.localizedDescription
        case let .audioOutput(e): e.localizedDescription
        }
    }
}

extension AppError.UnavailableFeatureError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .unavailableFeature(name):
            "\(name) is not available in this build."
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
