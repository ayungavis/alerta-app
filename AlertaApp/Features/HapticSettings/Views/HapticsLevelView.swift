import SwiftData
import SwiftUI

struct HapticsLevelView: View {
    var viewModel: HapticsSettingsViewModel
    var manager: CoreHapticService

    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("Alert Level")
                    .soraFont(
                        .headline,
                        emphasized: true,
                        color: AppColors.secondary
                    )
                    .padding(.top, 20)

                VStack(spacing: 12) {
                    ForEach(Urgency.allCases, id: \.rawValue) { level in
                        NavigationLink(
                            destination: HapticsSelectionView(
                                level: level,
                                viewModel: viewModel,
                                manager: manager
                            )
                        ) {
                            HStack {
                                Text(level.displayName)
                                    .soraFont(.callout, color: level.color)

                                Spacer()

                                Text(viewModel.selections[level] ?? "")
                                    .soraFont(.caption1)
                                    .foregroundColor(.textSecondary)

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.textTertiary)
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.leading, 8)
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 64)
                            .background(AppColors.surfacePrimary)
                            .cornerRadius(12)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Haptics")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Haptics")
                    .soraFont(.title2, emphasized: true)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HapticsLevelView(
            viewModel: HapticsSettingsViewModel(
                modelContext: try! ModelContainer(
                    for: UserSettingsModel.self,
                    CustomPatternModel.self
                ).mainContext
            ),
            manager: CoreHapticService()
        )
    }
    .preferredColorScheme(.dark)
}
