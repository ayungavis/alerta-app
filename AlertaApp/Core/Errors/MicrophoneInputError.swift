//
//  MicrophoneInputError.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 05/06/26.
//

import Foundation

extension AppError {
    enum MicrophoneInputError {
        case microphoneUnavailable
        case invalidInputFormat
        case audioEngineFailed(message: String)
    }
}

extension AppError.MicrophoneInputError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .microphoneUnavailable:
            "Microphone is unavailable."
        case .invalidInputFormat:
            "Invalid input format."
        case let .audioEngineFailed(message):
            "An unexpected error occurred: \(message)."
        }
    }
}
