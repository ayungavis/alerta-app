import CoreHaptics
import SwiftUI

struct AwarenessView: View {
    @State private var viewModel: AwarenessViewModel
    @Environment(\.colorScheme) private var colorScheme

    init() {
        let hapticService: HapticFeedbackProviding
        if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
            let defaultPatterns: [Urgency: HapticPatternConfig] = [
                .low: HapticPatternConfig(events: [
                    CHHapticEvent(eventType: .hapticTransient, parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
                    ], relativeTime: 0)
                ]),
                .medium: HapticPatternConfig(events: [
                    CHHapticEvent(eventType: .hapticContinuous, parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                    ], relativeTime: 0, duration: 0.5)
                ]),
                .high: HapticPatternConfig(events: [
                    CHHapticEvent(eventType: .hapticContinuous, parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
                    ], relativeTime: 0, duration: 1.0)
                ]),
                .critical: HapticPatternConfig(events: [
                    CHHapticEvent(eventType: .hapticContinuous, parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
                    ], relativeTime: 0, duration: 2.0)
                ])
            ]
            hapticService = CoreHapticsService(patternMap: defaultPatterns)
        } else {
            hapticService = FallbackHapticService()
        }

        _viewModel = State(initialValue: AwarenessViewModel(
            monitoringService: AudioMonitoringService(),
            permissionProvider: SystemMicrophonePermissionProvider(),
            feedbackService: CueFeedbackService(),
            hapticService: hapticService
        ))
    }

    private var isMonitoring: Bool {
        viewModel.isRunning
    }

    private var alertGlowColor: Color {
        guard let event = viewModel.latestEvent else { return .clear }
        switch event.urgency {
        case .low: return AppColors.alertInfo.opacity(0.16)
        case .medium: return AppColors.alertLow.opacity(0.16)
        case .high: return AppColors.alertMedium.opacity(0.16)
        case .critical: return AppColors.alertCritical.opacity(0.16)
        }
    }

    private var statusLabel: String {
        if case .calibrating = viewModel.calibrationState { return "Monitoring.." }
        if isMonitoring, viewModel.latestEvent == nil { return "Processing.." }
        if isMonitoring { return "" }
        return "Idle mode"
    }

    private var headerColor: Color {
        if isMonitoring { return AppColors.primaryDark }
        return AppColors.secondary
    }

    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()

            if viewModel.latestEvent != nil, alertGlowColor != .clear {
                Circle()
                    .fill(alertGlowColor)
                    .frame(width: 320, height: 320)
                    .blur(radius: 60)
                    .offset(x: -136, y: -200)

                Circle()
                    .fill(alertGlowColor)
                    .frame(width: 256, height: 256)
                    .blur(radius: 50)
                    .offset(x: 100, y: 100)
            }

            VStack(spacing: 0) {
                Spacer()

                Text("ALERTA")
                    .font(AppFont.soraBold(28))
                    .foregroundStyle(headerColor)

                AudioBarsVisualizer(
                    bands: viewModel.latestSpectrum.bands,
                    isActive: isMonitoring
                )
                .padding(.top, 32)

                if !statusLabel.isEmpty {
                    Text(statusLabel)
                        .font(AppFont.soraSemiBold(17))
                        .foregroundStyle(isMonitoring ? AppColors.primary : AppColors.secondary)
                        .padding(.top, 12)
                }

                if let event = viewModel.latestEvent {
                    DetectionAlertView(event: event)
                        .padding(.top, 24)
                        .transition(.scale.combined(with: .opacity))
                }

                if !isMonitoring, viewModel.latestEvent == nil {
                    Text("Alerta will notify you through these cues.")
                        .font(AppFont.soraRegular(16))
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 32)
                        .padding(.horizontal, 40)

                    HStack(spacing: 6) {
                        CueBadgeView(icon: "iphone.radiowaves.left.and.right", label: "Haptics")
                        CueBadgeView(icon: "speaker.wave.2", label: "Sound")
                    }
                    .padding(.top, 16)
                }

                Spacer()

                if !isMonitoring, viewModel.latestEvent == nil {
                    Text(
                        "Alerts may be incorrect, delayed, or not detected at all. Do not rely solely on this app for your safety."
                    )
                    .font(AppFont.soraRegular(11))
                    .foregroundStyle(AppColors.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)

                    Button {
                        Task { await viewModel.start() }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 17, weight: .semibold))
                            Text("Start")
                                .font(AppFont.soraSemiBold(17))
                        }
                        .foregroundStyle(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.buttonDefault)
                        .clipShape(Capsule())
                    }
                    .disabled(!viewModel.canStart)
                } else {
                    Button {
                        viewModel.stop()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 17, weight: .semibold))
                            Text("Stop")
                                .font(AppFont.soraSemiBold(17))
                        }
                        .foregroundStyle(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.buttonDestructive)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
            .animation(.easeInOut(duration: 0.3), value: viewModel.isRunning)
            .animation(.easeInOut(duration: 0.3), value: viewModel.latestEvent?.id)
            .animation(.easeInOut(duration: 0.3), value: viewModel.calibrationState)
        }
        .onDisappear {
            viewModel.stop()
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Idle") {
    NavigationStack {
        AwarenessView()
    }
}
