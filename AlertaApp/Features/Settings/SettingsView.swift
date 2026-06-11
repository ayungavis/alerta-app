import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    let hapticService: CoreHapticService

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundPrimary.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 32) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Alert")
                                    .soraFont(
                                        .headline,
                                        emphasized: true,
                                        color: AppColors.primary
                                    )

                                VStack(spacing: 12) {
                                    NavigationLink(destination: HapticsSettingsView(hapticService: hapticService)) {
                                        SettingsMenuRow(
                                            icon: "iphone.gen3.radiowaves.left.and.right",
                                            title: "Haptics"
                                        )
                                    }

                                    NavigationLink(
                                        destination: AudioSettingsView(
                                            manager: AudioOutputService()
                                        )
                                    ) {
                                        SettingsMenuRow(
                                            icon: "airpods.max",
                                            title: "Audio"
                                        )
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Display")
                                    .soraFont(
                                        .headline,
                                        emphasized: true,
                                        color: AppColors.primary
                                    )

                                HStack {
                                    Image(systemName: "moon")
                                        .foregroundColor(AppColors.primary)
                                        .font(.system(size: 20))
                                        .frame(width: 32)

                                    Text("Theme")
                                        .soraFont(size: 16, weight: .regular)
                                        .foregroundColor(AppColors.textPrimary)

                                    Spacer()

                                    ZStack {
                                        Capsule()
                                            .stroke(AppColors.primary, lineWidth: 1)
                                            .frame(width: 166, height: 32)

                                        HStack(spacing: 0) {
                                            Button("DARK") {
                                                isDarkMode = true
                                            }
                                            .soraFont(
                                                size: 12,
                                                weight: .semiBold,
                                                color: isDarkMode
                                                    ? AppColors.buttonText
                                                    : AppColors.buttonDisabled
                                            )
                                            .frame(width: 83, height: 32)
                                            .background(isDarkMode ? AppColors.primary : .clear)
                                            .clipShape(Capsule())

                                            Button("LIGHT") {
                                                isDarkMode = false
                                            }
                                            .soraFont(
                                                size: 12,
                                                weight: .semiBold,
                                                color: !isDarkMode
                                                    ? AppColors.buttonText
                                                    : AppColors.buttonDisabled
                                            )
                                            .frame(width: 83, height: 32)
                                            .background(!isDarkMode ? AppColors.primary : .clear)
                                            .clipShape(Capsule())
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 64)
                                .background(AppColors.surfacePrimary)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .task {
                UINavigationBar.appearance().largeTitleTextAttributes =
                    [
                        .font: UIFont(name: "Sora-Bold", size: 34)
                            ?? .systemFont(ofSize: 34, weight: .bold)
                    ] as [NSAttributedString.Key: Any]
            }
        }
    }
}

#Preview {
    SettingsView(hapticService: CoreHapticService())
        .preferredColorScheme(.dark)
}
