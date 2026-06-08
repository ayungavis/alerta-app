import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    let historyStore: SessionHistoryStore

    var body: some View {
        TabView(selection: $selectedTab) {
            AwarenessView(historyStore: historyStore)
                .tabItem {
                    Image(systemName: "waveform")
                    Text("Home")
                }
                .tag(0)

            Text("History Screen")
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(2)
        }
        .tint(AppColors.cyan)
    }
}

#Preview {
    MainTabView(
        historyStore: SessionHistoryStore(
            fileURL: FileManager.default.temporaryDirectory
                .appendingPathComponent("AlertaAppPreviewSessionHistory.json", isDirectory: false),
            fileManager: .default
        )
    )
}
