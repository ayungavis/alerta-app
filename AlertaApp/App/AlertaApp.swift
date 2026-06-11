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
    @AppStorage("isDarkMode") private var isDarkMode = true

    @State private var router = AppRouter()
    @State private var hapticService = CoreHapticService()
    
    let container: ModelContainer = .appContainer()

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
                        ), hapticService: hapticService
                    )
                } else {
                    WelcomeView()
                }
            }
            .environment(router)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            //            .environment(sessionHistoryStore)
        }
        .modelContainer(container)
    }
}
