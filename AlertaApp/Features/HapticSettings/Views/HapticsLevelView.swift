import SwiftUI

struct HapticsLevelView: View {
    var viewModel: HapticsSettingsViewModel
    var manager: HapticRecorderManager

    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("Alert Level")
                    .soraFont(size: 17, weight: .semiBold)
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.top, 20)

                VStack(spacing: 12) {
                    ForEach(Urgency.allCases, id: \.rawValue) { level in
                        NavigationLink(destination: HapticsSelectionView(
                            level: level,
                            viewModel: viewModel,
                            manager: manager
                        )) {
                            HStack {
                                Text(level.displayName)
                                    .soraFont(size: 16, weight: .regular)
                                    .foregroundColor(level.color)

                                Spacer()

                                Text(viewModel.selections[level] ?? "")
                                    .soraFont(size: 12, weight: .regular)
                                    .foregroundColor(.textSecondary)

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
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
                    .soraFont(size: 22, weight: .bold)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HapticsLevelView(
            viewModel: HapticsSettingsViewModel(),
            manager: HapticRecorderManager()
        )
    }
    .preferredColorScheme(.dark)
}
