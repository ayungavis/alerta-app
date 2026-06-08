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
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark").font(.title2).foregroundStyle(
                            AppColors.textPrimary)
                    }
                    Spacer()
                    Text("New Vibration").font(.title3).fontWeight(.semibold).foregroundStyle(
                        AppColors.textPrimary)
                    Spacer()
                    Button(action: {
                        if !manager.recordedPattern.isEmpty, !patternName.isEmpty {
                            let newPattern = CustomPattern(
                                name: patternName, steps: manager.recordedPattern)
                            viewModel.customPatterns.append(newPattern)
                        }
                        dismiss()
                    }) {
                        Text("SAVE")
                            .soraFont(size: 12, weight: .bold)
                            .foregroundStyle(AppColors.buttonText)
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(
                                patternName.isEmpty || manager.recordedPattern.isEmpty
                                    ? AppColors
                                        .textTertiary
                                    : AppColors
                                        .cyan
                            ).cornerRadius(20)
                    }
                    .disabled(patternName.isEmpty || manager.recordedPattern.isEmpty)
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
                                    ? AppColors.textTertiary.opacity(0.3) : AppColors.cyan,
                                lineWidth: 1
                            )
                    )
                    .padding(.horizontal)

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isTouching ? AppColors.primary.opacity(0.15) : Color.clear)

                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            manager.isRecording ? AppColors.systemError : AppColors.cyan,
                            style: StrokeStyle(lineWidth: 1, dash: [6])
                        )

                    VStack(spacing: AppSpacing.large) {
                        Circle()
                            .fill(Color(white: 0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "iphone.radiowaves.left.and.right")
                                    .font(.system(size: 32))
                                    .foregroundStyle(
                                        manager.isRecording ? AppColors.systemError : AppColors.cyan
                                    )
                            )

                        VStack(spacing: 8) {
                            Text(manager.isRecording ? "RECORDING..." : "TAP TO CREATE VIBRATION")
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundStyle(
                                    manager.isRecording
                                        ? AppColors.systemError : AppColors.textPrimary)

                            Text("TAP OR HOLD ANYWHERE")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundStyle(AppColors.cyan)
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
                        let events = manager.getEvents(fromSteps: manager.recordedPattern)
                        manager.playHaptic(events: events)
                    }) {
                        HStack {
                            Image(systemName: "play")
                            Text("PLAY").font(.system(size: 14, design: .monospaced))
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
                    .disabled(manager.recordedPattern.isEmpty || manager.isRecording)

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
                                    .fill(Color(red: 1.0, green: 0.7, blue: 0.7))
                                    .frame(width: 12, height: 12)
                            }

                            Text(manager.isRecording ? "STOP" : "RECORD")
                                .soraFont(size: 14, weight: .semiBold)
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
