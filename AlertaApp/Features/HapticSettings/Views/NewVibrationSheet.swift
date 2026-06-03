import SwiftUI

struct NewVibrationSheet: View {
    @Environment(\.dismiss) var dismiss
    var manager: HapticRecorderManager
    var viewModel: HapticsSettingsViewModel

    @State private var patternName: String = ""
    @State private var isTouching = false

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: AppSpacing.large) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark").font(.title2).foregroundColor(.white)
                    }
                    Spacer()
                    Text("New Vibration").font(.title3).fontWeight(.semibold).foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        if !manager.recordedPattern.isEmpty, !patternName.isEmpty {
                            let newPattern = CustomPattern(name: patternName, steps: manager.recordedPattern)
                            viewModel.customPatterns.append(newPattern)
                        }
                        dismiss()
                    }) {
                        Text("SAVE")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(patternName.isEmpty || manager.recordedPattern.isEmpty ? Color.gray : AppColors
                                .cyan).cornerRadius(20)
                    }
                    .disabled(patternName.isEmpty || manager.recordedPattern.isEmpty)
                }
                .padding(.horizontal).padding(.top, 24)

                TextField("Pattern Name", text: $patternName)
                    .font(.system(size: 16, weight: .medium))
                    .padding()
                    .background(AppColors.card)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(patternName.isEmpty ? Color.gray.opacity(0.3) : AppColors.cyan, lineWidth: 1)
                    )
                    .padding(.horizontal)

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isTouching ? AppColors.cyan.opacity(0.15) : Color.clear)

                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            manager.isRecording ? Color.red : AppColors.cyan,
                            style: StrokeStyle(lineWidth: 1, dash: [6])
                        )

                    VStack(spacing: AppSpacing.large) {
                        Circle()
                            .fill(Color(white: 0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "iphone.radiowaves.left.and.right")
                                    .font(.system(size: 32))
                                    .foregroundColor(manager.isRecording ? .red : AppColors.cyan)
                            )

                        VStack(spacing: 8) {
                            Text(manager.isRecording ? "RECORDING..." : "TAP TO CREATE VIBRATION")
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundColor(manager.isRecording ? .red : .white)

                            Text("TAP OR HOLD ANYWHERE")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(AppColors.cyan)
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
                    Button(action: { manager.playRecordedPattern() }) {
                        HStack {
                            Image(systemName: "play")
                            Text("PLAY").font(.system(size: 14, design: .monospaced))
                        }
                        .foregroundColor(manager.recordedPattern.isEmpty ? .gray : .white)
                        .frame(maxWidth: .infinity).frame(height: 56)
                        .background(AppColors.card).cornerRadius(16)
                    }
                    .disabled(manager.recordedPattern.isEmpty || manager.isRecording)

                    Button(action: {
                        if manager.isRecording { manager.stopRecordingSession() }
                        else { manager.startRecordingSession() }
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
                                .font(.system(size: 14, design: .monospaced))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity).frame(height: 56)
                        .background(AppColors.card).cornerRadius(16)
                    }
                }
                .padding(.horizontal).padding(.bottom, 24)
            }
        }
    }
}
