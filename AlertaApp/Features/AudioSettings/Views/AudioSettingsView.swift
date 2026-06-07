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
                            .soraFont(size: 16, weight: .bold)
                            .foregroundColor(AppColors.primary)
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
                .padding(.horizontal, 20)
                .padding(.top, 24)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Voice Speed")
                            .soraFont(size: 16, weight: .bold)
                            .foregroundColor(AppColors.primary)
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
                .padding(.horizontal, 20)

                Button(action: {
                    testVoice()
                }) {
                    Text("Test Voice Settings")
                        .soraFont(size: 16, weight: .semiBold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(AppColors.primary)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer()
            }
        }
        .navigationTitle("Audio Settings")
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
