//
//  AudioSettingsView.swift
//  AlertaApp
//
//  Created by Kyky on 07/06/26.
//

import SwiftUI

struct AudioSettingsView: View {
    @State private var viewModel = AudioSettingsViewModel()
    var manager: AudioOutputService

    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Voice Volume")
                            .soraFont(.headline, emphasized: true, color: AppColors.secondary)
                        Spacer()
                        Text("\(Int(viewModel.voiceVolume * 100))%")
                            .soraFont(size: 14, weight: .regular)
                            .foregroundColor(.gray)
                    }

                    Slider(
                        value: $viewModel.voiceVolume,
                        in: 0.0 ... 1.0,
                        minimumValueLabel: Image(systemName: "speaker.fill")
                            .foregroundColor(.gray)
                            .frame(width: 30),
                        maximumValueLabel: Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.gray)
                            .frame(width: 30)
                    ) {
                        Text("Volume")
                    }
                    .tint(AppColors.primary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Voice Speed")
                            .soraFont(.headline, emphasized: true, color: AppColors.secondary)
                        Spacer()
                        Text(speedLabel(viewModel.voiceSpeed))
                            .soraFont(size: 14, weight: .regular)
                            .foregroundColor(.gray)
                    }

                    Slider(
                        value: $viewModel.voiceSpeed,
                        in: 0.0 ... 1.0,
                        minimumValueLabel: Image(systemName: "tortoise.fill")
                            .foregroundColor(.gray)
                            .frame(width: 30),
                        maximumValueLabel: Image(systemName: "hare.fill")
                            .foregroundColor(.gray)
                            .frame(width: 30)
                    ) {
                        Text("Speed")
                    }
                    .tint(AppColors.primary)
                }

                Button(action: {
                    testVoice()
                }) {
                    Text("Test Voice Settings")
                        .soraFont(.body, color: AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                }
                .background(AppColors.primary)
                .cornerRadius(30)

                Spacer()
            }
            .padding(AppSpacing.large)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Audio Settings")
                    .soraFont(.title2, emphasized: true)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func speedLabel(_ value: Float) -> String {
        if value < 0.4 { return "Slow" }
        if value > 0.6 { return "Fast" }
        return "Normal"
    }

    private func testVoice() {
        manager.stopSpeaking()
        manager.playTestVoice(speed: viewModel.voiceSpeed, volume: viewModel.voiceVolume)
    }
}

#Preview {
    NavigationStack {
        AudioSettingsView(manager: AudioOutputService())
            .preferredColorScheme(.dark)
    }
}
