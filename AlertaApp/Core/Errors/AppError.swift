import Foundation
import SwiftData

/// Unified error type for the application.
/// Add new top-level cases per subsystem; nest detail via associated enums.
enum AppError: Error {
    case unavailableFeature(UnavailableFeatureError)
    case audioOutput(AudioOutputError)
    case microphoneInput(MicrophoneInputError)
    case haptic(HapticError)
    case dataError(DataError)
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .unavailableFeature(e):
            e.localizedDescription
        case let .audioOutput(e):
            e.localizedDescription
        case let .microphoneInput(e):
            e.localizedDescription
        case let .haptic(e):
            e.localizedDescription
        case let .dataError(e):
            e.localizedDescription
        }
    }
}
