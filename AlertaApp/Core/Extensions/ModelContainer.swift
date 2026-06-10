//
//  ModelContainer.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 10/06/26.
//

import SwiftData
import Foundation

extension ModelContainer {
    static func appContainer() -> ModelContainer {
        do {
            return try ModelContainer(for: AwarenessSessionRecord.self)
        } catch {
            fatalError(AppError.dataError(.containerInitializationFailed(error)).localizedDescription)
        }
    }
}
