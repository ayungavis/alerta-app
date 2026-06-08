//
//  AlertaApp.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import SwiftUI

@main
struct AlertaApp: App {
    @State private var router = AppRouter()
    @State private var sessionHistoryStore = SessionHistoryStore(
        fileURL: SessionHistoryStore.defaultFileURL(),
        fileManager: .default
    )

    var body: some Scene {
        WindowGroup {
            Group {
                if router.hasEnteredMainApp {
                    MainTabView(historyStore: sessionHistoryStore)
                } else {
                    WelcomeView()
                }
            }
            .environment(router)
            .environment(sessionHistoryStore)
        }
    }
}
