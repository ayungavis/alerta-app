import SwiftUI

struct HapticsSettingsView: View {
    @State private var viewModel = HapticsSettingsViewModel()
    @State private var manager = CoreHapticService()

    var body: some View {
        HapticsLevelView(
            viewModel: viewModel,
            manager: manager
        )
    }
}

#Preview {
    HapticsSettingsView()
}
