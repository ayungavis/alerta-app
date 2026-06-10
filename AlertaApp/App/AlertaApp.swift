//
//  AlertaApp.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import SwiftData
import SwiftUI

@main
struct AlertaApp: App {
    @State private var router = AppRouter()
    let container: ModelContainer = .appContainer()
    private let monitoringConfiguration = AudioMonitoringConfiguration()

    //    @State private var sessionHistoryStore = SessionHistoryStore(
    //        fileURL: SessionHistoryStore.defaultFileURL(),
    //        fileManager: .default
    //    )

    var body: some Scene {
        WindowGroup {
            Group {
                if router.hasEnteredMainApp {
                    MainTabView(
                        historyStore: SessionHistoryStore(
                            modelContext: container.mainContext,
                            detectionCooldown: monitoringConfiguration.detectionCooldown
                        )
                    )
                } else {
                    NavigationStack {
                        WelcomeView()
                    }
                }
            }
            .environment(router)
            //            .environment(sessionHistoryStore)
        }
        .modelContainer(container)
    }
}
