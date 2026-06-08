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

    var body: some Scene {
        WindowGroup {
            Group {
                if router.hasEnteredMainApp {
                    MainTabView()
                } else {
                    WelcomeView()
                }
            }
            .environment(router)
        }
    }
}
