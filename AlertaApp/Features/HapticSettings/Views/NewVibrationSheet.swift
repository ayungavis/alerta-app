import SwiftUI

struct NewVibrationSheet: View {
    @Environment(\.dismiss) var dismiss
    var manager: CoreHapticService
    var viewModel: HapticsSettingsViewModel

    @State private var patternName: String = ""
    @State private var isTouching = false

    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: AppSpacing.large) {
                HStack(alignment: .center) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark").font(.title2)
                                .foregroundStyle(
                                    AppColors.textPrimary
                                )
                        }
                        Text("New Vibration").font(.title3).fontWeight(.semibold)
                            .foregroundStyle(
                                AppColors.textPrimary
                            )
                    }
                    Spacer()
                    Button(action: {
                        if !manager.recordedPattern.isEmpty,
                           !patternName.isEmpty
                        {
                            let newPattern = CustomPattern(
                                name: patternName,
                                steps: manager.recordedPattern
                            )
                            viewModel.customPatterns.append(newPattern)
                        }
                        dismiss()
                    }) {
                        Text("Save")
                            .soraFont(.body, emphasized: true)
                            .foregroundStyle(AppColors.buttonText)
                            .padding(AppSpacing.medium)
                            .background(
                                patternName.isEmpty
                                    || manager.recordedPattern.isEmpty
                                    ? AppColors
                                    .textTertiary
                                    : AppColors
                                    .cyan
                            ).cornerRadius(.infinity)
                    }
                    .disabled(
                        patternName.isEmpty || manager.recordedPattern.isEmpty
                    )
                }
                .padding(.horizontal).padding(.top, 24)

                TextField("Pattern Name", text: $patternName)
                    .soraFont(size: 16, weight: .regular)
                    .padding()
                    .background(AppColors.card)
                    .foregroundStyle(AppColors.textPrimary)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                patternName.isEmpty
                                    ? AppColors.textTertiary.opacity(0.3)
                                    : AppColors.cyan,
                                lineWidth: 1
                            )
                    )
                    .padding(.horizontal)

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            isTouching
                                ? AppColors.primary.opacity(0.15) : Color.clear
                        )

                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            manager.isRecording
                                ? AppColors.systemError : AppColors.cyan,
                            style: StrokeStyle(lineWidth: 1, dash: [6])
                        )

                    VStack(spacing: AppSpacing.large) {
                        Circle()
                            .fill(Color(white: 0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(
                                    systemName:
                                    "iphone.radiowaves.left.and.right"
                                )
                                .font(.system(size: 32))
                                .foregroundStyle(
                                    manager.isRecording
                                        ? AppColors.systemError : AppColors.cyan
                                )
                            )

                        VStack(spacing: 8) {
                            Text(
                                manager.isRecording
                                    ? "Recording..." : "Tap to create vibration"
                            )
                            .soraFont(.title3, emphasized: true)
                            .foregroundStyle(
                                manager.isRecording
                                    ? AppColors.systemError
                                    : AppColors.textPrimary
                            )

                            Text("Tap or hold anywhere")
                                .soraFont(.body, color: AppColors.textSecondary)
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .padding(.horizontal)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !isTouching, manager.isRecording {
                                isTouching = true
                                manager.touchDown()
                            }
                        }
                        .onEnded { _ in
                            if manager.isRecording {
                                isTouching = false
                                manager.touchUp()
                            }
                        }
                )

                HStack(spacing: 16) {
                    Button(action: {
                        let events = manager.getEvents(
                            fromSteps: manager.recordedPattern
                        )
                        manager.playHaptic(events: events)
                    }) {
                        HStack {
                            Image(systemName: "play")
                            Text("Play")
                                .soraFont(
                                    .body,
                                    emphasized: true,
                                    color: manager.recordedPattern.isEmpty
                                        ? AppColors.textTertiary
                                        : AppColors.textPrimary
                                )
                        }
                        .foregroundStyle(
                            manager.recordedPattern.isEmpty
                                ? AppColors.textTertiary
                                : AppColors
                                .textPrimary
                        )
                        .frame(maxWidth: .infinity).frame(height: 56)
                        .background(AppColors.card).cornerRadius(16)
                    }
                    .disabled(
                        manager.recordedPattern.isEmpty || manager.isRecording
                    )

                    Button(action: {
                        if manager.isRecording {
                            manager.stopRecordingSession()
                        } else {
                            manager.startRecordingSession()
                        }
                    }) {
                        HStack {
                            if manager.isRecording {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.red)
                                    .frame(width: 12, height: 12)
                            } else {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 12, height: 12)
                            }

                            Text(manager.isRecording ? "Stop" : "Record")
                                .soraFont(
                                    .body,
                                    emphasized: true
                                )
                        }
                        .foregroundStyle(AppColors.textPrimary)
                        .frame(maxWidth: .infinity).frame(height: 56)
                        .background(AppColors.card).cornerRadius(16)
                    }
                }
                .padding(.horizontal).padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    NavigationStack {
        NewVibrationSheet(
            manager: CoreHapticService(),
            viewModel: HapticsSettingsViewModel()
        )
    }
    .preferredColorScheme(.dark)
}
