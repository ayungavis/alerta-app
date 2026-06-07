//
//  HapticError.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 05/06/26.
//

import Foundation

extension AppError {
    enum HapticError {
        case hapticEngineCreationFails(String)
        case hapticEngineStartFails(String)
        case hapticPlaybackFails(String)
    }
}

extension AppError.HapticError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .hapticEngineCreationFails(message):
            message
        case let .hapticEngineStartFails(message):
            message
        case let .hapticPlaybackFails(message):
            message
        }
    }
}
