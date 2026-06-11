import SwiftData
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    let historyStore: SessionHistoryStore
    let hapticService: CoreHapticService

    var body: some View {
        TabView(selection: $selectedTab) {
            AwarenessView(historyStore: historyStore, hapticService: hapticService)
                .tabItem {
                    Image(systemName: "waveform")
                    Text("Home")
                }
                .tag(0)

            HistoryView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }
                .tag(1)

            SettingsView(hapticService: hapticService)
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
    let container = ModelContainer.appContainer()
    let monitoringConfiguration = AudioMonitoringConfiguration()
    let store = SessionHistoryStore(
        modelContext: container.mainContext,
        detectionCooldown: monitoringConfiguration.detectionCooldown
    )

    MainTabView(historyStore: store, hapticService: CoreHapticService())
}
