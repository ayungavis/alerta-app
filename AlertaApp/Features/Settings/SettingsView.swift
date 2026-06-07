import SwiftUI

struct SettingsView: View {
    @State private var viewModel = HapticsSettingsViewModel()
    @State private var hapticManager = CoreHapticService()

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundPrimary.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    Text("Settings")
                        .soraFont(size: 34, weight: .bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 24)

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 32) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Alert")
                                    .soraFont(size: 17, weight: .semiBold)
                                    .foregroundColor(AppColors.primary)

                                VStack(spacing: 12) {
                                    NavigationLink(destination: HapticsLevelView(
                                        viewModel: viewModel,
                                        manager: hapticManager
                                    )) {
                                        SettingsMenuRow(icon: "iphone.gen3.radiowaves.left.and.right", title: "Haptics")
                                    }

                                    NavigationLink(destination: AudioSettingsView(manager: AudioOutputService())) {
                                        SettingsMenuRow(icon: "airpods.max", title: "Audio")
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Display")
                                    .soraFont(size: 17, weight: .semiBold)
                                    .foregroundColor(AppColors.primary)

                                HStack {
                                    Image(systemName: "moon")
                                        .foregroundColor(AppColors.primary)
                                        .font(.system(size: 20))
                                        .frame(width: 32)

                                    Text("Theme")
                                        .soraFont(size: 16, weight: .regular)
                                        .foregroundColor(.white)

                                    Spacer()

                                    ZStack {
                                        Capsule()
                                            .stroke(AppColors.primary, lineWidth: 1)
                                            .frame(width: 166, height: 32)

                                        HStack(spacing: 0) {
                                            Text("DARK")
                                                .soraFont(size: 12, weight: .semiBold)
                                                .foregroundColor(.black)
                                                .frame(width: 83, height: 32)
                                                .background(AppColors.primary)
                                                .clipShape(Capsule())

                                            Text("LIGHT")
                                                .soraFont(size: 12, weight: .semiBold)
                                                .foregroundColor(.gray)
                                                .frame(width: 83, height: 32)
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
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
