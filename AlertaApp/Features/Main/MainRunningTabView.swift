import SwiftUI

struct MainRunningTabView: View {
    var body: some View {
        TabView {
            // Tab 1: Home (Kosongan dulu buat dummy)
            Text("Home Screen")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            // Tab 2: History (Kosongan dulu buat dummy)
            Text("History Screen")
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }
            
            // Tab 3: Haptics (Ini halaman yang baru aja kita buat!)
            HapticsSettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        // Mengubah warna ikon tab yang sedang aktif jadi Cyan
        .tint(AppColors.cyan)
        // Memaksa aplikasi selalu dalam mode gelap (Dark Mode)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MainRunningTabView()
}