//
//  ModelContainer.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 10/06/26.
//

import Foundation
import SwiftData

extension ModelContainer {
    static func appContainer() -> ModelContainer {
        do {
            return try ModelContainer(
                for: AwarenessSessionRecord.self,
                UserSettingsModel.self,
                CustomPatternModel.self
            )
        } catch {
            fatalError(
                AppError.dataError(.containerInitializationFailed(error))
                    .localizedDescription
            )
        }
    }
}
