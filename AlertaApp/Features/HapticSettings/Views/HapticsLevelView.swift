import SwiftUI

struct HapticsLevelView: View {
    var viewModel: HapticsSettingsViewModel
    var manager: HapticRecorderManager

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("Alert Level")
                    .soraFont(size: 16, weight: .bold)
                    .foregroundColor(AppColors.cyan)
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
                                    .soraFont(size: 16, weight: .medium)
                                    .foregroundColor(level.color)

                                Spacer()

                                Text(viewModel.selections[level] ?? "")
                                    .soraFont(size: 14, weight: .regular)
                                    .foregroundColor(.gray)

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.leading, 8)
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 64)
                            .background(AppColors.card)
                            .cornerRadius(12)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Haptics")
        .navigationBarTitleDisplayMode(.inline)
    }
}
