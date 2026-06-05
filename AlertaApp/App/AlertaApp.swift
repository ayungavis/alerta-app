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
            NavigationStack(path: $router.path) {
                WelcomeView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .mainTab:
                            MainTabView()
                        }
                    }
            }
            .environment(router)
        }
    }
}
