//
//  AudioSettingsView.swift
//  AlertaApp
//

import SwiftData
import SwiftUI

struct AudioSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: AudioSettingsViewModel?
    var manager: AudioOutputService

    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()

            if let viewModel {
                contentView(viewModel: viewModel)
            }
        }
        .onAppear {
            guard viewModel == nil else { return }
            viewModel = AudioSettingsViewModel(modelContext: modelContext)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Audio Settings")
                    .soraFont(.title2, emphasized: true)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func contentView(viewModel: AudioSettingsViewModel) -> some View {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Voice Volume")
                        .soraFont(
                            .headline,
                            emphasized: true,
                            color: AppColors.secondary
                        )
                    Spacer()
                    Text("\(Int(viewModel.voiceVolume * 100))%")
                        .soraFont(size: 14, weight: .regular)
                        .foregroundColor(.gray)
                }

                Slider(
                    value: Binding(
                        get: { viewModel.voiceVolume },
                        set: { viewModel.voiceVolume = $0 }
                    ),
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
                        .soraFont(
                            .headline,
                            emphasized: true,
                            color: AppColors.secondary
                        )
                    Spacer()
                    Text(speedLabel(viewModel.voiceSpeed))
                        .soraFont(size: 14, weight: .regular)
                        .foregroundColor(.gray)
                }

                Slider(
                    value: Binding(
                        get: { viewModel.voiceSpeed },
                        set: { viewModel.voiceSpeed = $0 }
                    ),
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

            Button {
                manager.stopSpeaking()
                manager.playTestVoice(
                    speed: viewModel.voiceSpeed,
                    volume: viewModel.voiceVolume
                )
            } label: {
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

    private func speedLabel(_ value: Float) -> String {
        if value < 0.4 { return "Slow" }
        if value > 0.6 { return "Fast" }
        return "Normal"
    }
}

#Preview {
    NavigationStack {
        AudioSettingsView(manager: AudioOutputService())
            .preferredColorScheme(.dark)
            .modelContainer(ModelContainer.previewSettingsContainer())
    }
}
