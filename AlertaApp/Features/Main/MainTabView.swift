import SwiftUI
import SwiftData

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

            HistoryView()
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
    let container = ModelContainer.appContainer()
    let store = SessionHistoryStore(modelContext: container.mainContext)

    MainTabView(historyStore: store)
}
