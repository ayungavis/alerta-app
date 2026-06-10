//
//  SwiftDataError.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 10/06/26.
//

import Foundation
import SwiftData

extension AppError {
    enum DataError {
        case containerInitializationFailed(Error)
        case fetchFailed(Error)
        case saveFailed(Error)
        case unknown(Error)

        init(error: Error) {
            if let swiftDataError = error as? SwiftData.SwiftDataError {
                switch swiftDataError {
                case .missingModelContext:
                    self = .fetchFailed(error)
                case .loadIssueModelContainer:
                    self = .containerInitializationFailed(error)
                default:
                    self = .unknown(error)
                }
            } else {
                // Catch standard CoreData migration or disk space errors during saves
                let errorString = String(describing: error)
                if errorString.contains("save")
                    || errorString.contains("Cocoa 134030")
                {
                    self = .saveFailed(error)
                } else {
                    self = .unknown(error)
                }
            }
        }
    }
}

extension AppError.DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .containerInitializationFailed(let underlyingError):
            return
                "Failed to set up the local database. \(underlyingError.localizedDescription)"
        case .fetchFailed(let underlyingError):
            return
                "Could not retrieve saved items. \(underlyingError.localizedDescription)"
        case .saveFailed(let underlyingError):
            return
                "Could not save your changes. Your disk might be full. \(underlyingError.localizedDescription)"
        case .unknown(let underlyingError):
            return
                "An unexpected database error occurred. \(underlyingError.localizedDescription)"
        }
    }
}
