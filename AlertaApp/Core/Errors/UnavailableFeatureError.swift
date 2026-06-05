//
//  UnavailableFeatureError.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 05/06/26.
//

import Foundation

extension AppError {
    enum UnavailableFeatureError {
        /// A requested feature is not available in this build (e.g. missing entitlement, unsupported OS version).
        case unavailableFeature(name: String)
        case permissionDenied
        case sessionInterrupted
    }
}

extension AppError.UnavailableFeatureError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .unavailableFeature(name):
            "\(name) is not available in this build."
        case .permissionDenied:
            "Permission denied."
        case .sessionInterrupted:
            "Session was interrupted."
        }
    }
}
