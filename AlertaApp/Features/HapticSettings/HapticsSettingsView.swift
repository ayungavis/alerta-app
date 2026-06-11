import SwiftData
import SwiftUI

struct HapticsSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    let hapticService: CoreHapticService
    @State private var viewModel: HapticsSettingsViewModel?

    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            if let viewModel {
                HapticsLevelView(viewModel: viewModel, manager: hapticService)
            }
        }
        .onAppear {
            guard viewModel == nil else { return }
            let vm = HapticsSettingsViewModel(modelContext: modelContext)
            vm.bind(to: hapticService)
            viewModel = vm
        }
    }
}

#Preview {
    NavigationStack {
        HapticsSettingsView(hapticService: CoreHapticService())
            .preferredColorScheme(.dark)
            .modelContainer(try! ModelContainer(for: UserSettingsModel.self, CustomPatternModel.self))
    }
}
