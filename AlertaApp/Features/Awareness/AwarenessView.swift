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
        return viewModel.isRunning ? .listening : .idle
    }
    
    private var orbVolume: Float {
        guard let event = viewModel.latestEvent else { return 0 }
        return event.confidence
    }
    
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            
            VoiceOrbView(
                state: orbState,
                variant: .default,
                volume: orbVolume * 0.12,
                customColors: VariantColors.primary(for: colorScheme)
            )
            .frame(width: 380, height: 380)
            
            HStack(spacing: 6) {
                Circle()
                    .fill(viewModel.isRunning ? Color.green : Color.gray)
                    .frame(width: 8, height: 8)
                Text(viewModel.isRunning ? "Listening" : "Idle")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            if let event = viewModel.latestEvent {
                alertCard(event)
                    .transition(.scale.combined(with: .opacity))
            }
            
            Spacer()
            
            Button(viewModel.isRunning ? "Stop Session" : "Start Session") {
                if viewModel.isRunning {
                    viewModel.stop()
                } else {
                    Task { await viewModel.start() }
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .animation(.easeInOut(duration: 0.3), value: viewModel.isRunning)
        .animation(.easeInOut(duration: 0.3), value: viewModel.latestEvent?.id)
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
                .font(.system(size: 36, weight: .heavy))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.yellow)
        .foregroundStyle(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    NavigationStack {
        AwarenessView()
    }
}
