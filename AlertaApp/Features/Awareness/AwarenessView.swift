//
//  AwarenessView.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import SwiftUI

struct AwarenessView: View {
    @State private var viewModel = AwarenessViewModel(
        monitoringService: AudioMonitoringService(),
        permissionProvider: SystemMicrophonePermissionProvider(),
        feedbackService: CueFeedbackService()
    )

    @Environment(\.colorScheme) private var colorScheme
    @State private var flashSpeaking: Bool = false
    @State private var flashTask: Task<Void, Never>?

    private var orbState: VoiceOrbState {
        if flashSpeaking { return .speaking }
        if case .calibrating = viewModel.calibrationState { return .connecting }
        return viewModel.isRunning ? .listening : .idle
    }

    private var orbVolume: Float {
        guard let event = viewModel.latestEvent else { return 0 }
        return event.confidence
    }

    private var statusText: String {
        if case .calibrating = viewModel.calibrationState { return "Calibrating" }
        return viewModel.isRunning ? "Listening" : "Idle"
    }

    private var statusColor: Color {
        if case .calibrating = viewModel.calibrationState { return .orange }
        return viewModel.isRunning ? .green : .gray
    }

    private var buttonTitle: String {
        if case .calibrating = viewModel.calibrationState { return "Calibrating..." }
        return viewModel.isRunning ? "Stop Session" : "Start Session"
    }

    private var dominantHzText: String {
        let hz = viewModel.latestSpectrum.dominantFrequency
        guard hz > 0 else { return "—" }
        if hz >= 1000 { return String(format: "%.1f kHz", hz / 1000) }
        return String(format: "%.0f Hz", hz)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Spacer()

                VoiceOrbView(
                    state: orbState,
                    variant: .default,
                    volume: orbVolume * 0.12,
                    customColors: VariantColors.primary(for: colorScheme)
                )
                .frame(width: 280, height: 280)

                HStack(spacing: 6) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)
                    Text(statusText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if viewModel.latestSpectrum.bands.contains(where: { $0.energy > 0 }) {
                    DirectionIndicatorView(direction: viewModel.latestDirection)
                        .padding(.vertical, 4)

                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Text("Live")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(Color("textTertiary"))
                            Spacer()
                            Text(dominantHzText)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(Color("textTertiary"))
                        }
                        .padding(.horizontal, 24)

                        FrequencyBarsView(bands: viewModel.latestSpectrum.bands)

                        if let baseline = viewModel.baselineProfile {
                            HStack(spacing: 6) {
                                Text("Baseline")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundStyle(Color("textTertiary"))
                                Spacer()
                            }
                            .padding(.horizontal, 24)

                            FrequencyBarsView(bands: baseline.baseline.bands, style: .baseline)
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }

                if let event = viewModel.latestEvent {
                    alertCard(event)
                        .transition(.scale.combined(with: .opacity))
                }

                Spacer()

                Button(buttonTitle) {
                    if viewModel.isRunning {
                        viewModel.stop()
                    } else {
                        Task { await viewModel.start() }
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!viewModel.canStart && !viewModel.isRunning)
            }
            .padding()
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isRunning)
        .animation(.easeInOut(duration: 0.3), value: viewModel.latestEvent?.id)
        .animation(.easeInOut(duration: 0.3), value: viewModel.calibrationState)
        .onChange(of: viewModel.latestEvent?.id) { _, _ in
            guard viewModel.isRunning, viewModel.latestEvent != nil else { return }
            flashTask?.cancel()
            flashSpeaking = true
            flashTask = Task {
                try? await Task.sleep(for: .milliseconds(500))
                flashSpeaking = false
            }
        }
        .onDisappear {
            flashTask?.cancel()
            viewModel.stop()
        }
        .navigationTitle("Voice + Awareness")
    }

    private func alertCard(_ event: DetectionEvent) -> some View {
        VStack(spacing: 8) {
            Text(viewModel.rawDetectedSound)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(event.direction.rawValue)
                .font(.system(size: 28, weight: .heavy))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(urgencyColor(event.urgency))
        .foregroundStyle(Color("buttonText"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func urgencyColor(_ urgency: DetectionUrgency) -> Color {
        switch urgency {
        case .critical: Color("alertCritical")
        case .high: Color("alertMedium")
        case .medium: Color("alertLow")
        case .low: Color("alertInfo")
        }
    }
}

#Preview("Idle") {
    NavigationStack {
        AwarenessView()
    }
}
