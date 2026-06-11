//
//  ModelContainer.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 10/06/26.
//

import Foundation
import os
import SwiftData

extension ModelContainer {
    static func appContainer() -> ModelContainer {
        let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier ?? "AlertaApp",
            category: "SwiftData"
        )

        do {
            return try ModelContainer(
                for: AwarenessSessionRecord.self,
                UserSettingsModel.self,
                CustomPatternModel.self
            )
        } catch {
            let nsError = error as NSError

            guard isIncompatibleStoreError(nsError) else {
                fatalError(
                    
                AppError.dataError(.containerInitializationFailed(error))
                    .localizedDescription
            
                )
            }

            let storeURL = persistentStoreURL(for: nsError)

            do {
                try deletePersistentStoreFiles(at: storeURL)
                let storePath = storeURL.path
                let errorDomain = nsError.domain
                let errorCode = nsError.code

                logger.error(
                    "Deleted incompatible SwiftData store domain=\(errorDomain, privacy: .public) code=\(errorCode, privacy: .public)"
                )
                logger.error(
                    "Deleted SwiftData store url=\(storePath, privacy: .public)"
                )
                return try ModelContainer(for: AwarenessSessionRecord.self)
            } catch {
                fatalError(
                    AppError.dataError(.containerInitializationFailed(error)).localizedDescription
                )
            }
        }
    }

    private static func isIncompatibleStoreError(_ error: NSError) -> Bool {
        if error.domain == NSCocoaErrorDomain, error.code == 134_110 {
            return true
        }

        if let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError {
            return isIncompatibleStoreError(underlyingError)
        }

        return false
    }

    private static func persistentStoreURL(for error: NSError) -> URL {
        if let sourceURL = error.userInfo["sourceURL"] as? URL {
            return sourceURL
        }

        if let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError {
            return persistentStoreURL(for: underlyingError)
        }

        guard
            let applicationSupportURL = FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            ).first
        else {
            preconditionFailure("Application Support directory is unavailable for SwiftData store reset.")
        }

        return applicationSupportURL.appendingPathComponent("default.store", isDirectory: false)
    }

    private static func deletePersistentStoreFiles(at storeURL: URL) throws {
        let fileManager = FileManager.default
        let relatedURLs = [
            storeURL,
            URL(fileURLWithPath: storeURL.path + "-shm"),
            URL(fileURLWithPath: storeURL.path + "-wal")
        ]

        for url in relatedURLs where fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
    }
}
