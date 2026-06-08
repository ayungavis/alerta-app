//
//  AudioOutput.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 05/06/26.
//

import Foundation

extension AppError {
    enum AudioOutputError {
        /// The `AVAudioSession` could not be activated (e.g. interrupted by a call).
        case sessionActivationFailed(underlying: Error)
        /// The requested system sound ID is not available on this OS version.
        case systemSoundUnavailable(id: UInt32)
        /// The speech synthesiser rejected the utterance (empty string, bad locale, etc.).
        case utteranceRejected(reason: String)
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
