import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            AwarenessView()
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

            HapticsSettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(2)
        }
        .tint(AppColors.cyan)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainTabView()
}
