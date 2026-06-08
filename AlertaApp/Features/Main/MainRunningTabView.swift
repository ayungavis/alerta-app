import SwiftUI

struct MainRunningTabView: View {
    var body: some View {
        TabView {
            Text("Home Screen")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            HistoryView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                    Text("History")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .tint(AppColors.primary)
        .preferredColorScheme(.dark)
    }
}
