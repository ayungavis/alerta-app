import CoreHaptics
import SwiftData
import SwiftUI

struct AwarenessView: View {
    @State private var viewModel: AwarenessViewModel
    @State private var isStopping = false
    @State private var isShowingHelpMenuSheet = false
    @State private var selectedHelpContent: AwarenessHelpContent?
    @State private var stopTransitionTask: Task<Void, Never>?

    init(
        historyStore: SessionHistoryStore,
        hapticService: HapticFeedbackProviding
    ) {
        _viewModel = State(
            initialValue: AwarenessViewModel(
                monitoringService: AudioMonitoringService(),
                permissionProvider: SystemMicrophonePermissionProvider(),
                audioOutputService: AudioOutputService(),
                hapticService: hapticService,
                historyStore: historyStore
            )
        )
    }

    private var isMonitoring: Bool {
        viewModel.isRunning
    }

    private var presentationState: AwarenessPresentationState {
        if isStopping { return .stopping }
        if let event = viewModel.latestEvent { return .alert(event) }
        if case .calibrating = viewModel.calibrationState {
            return .calibrating
        }
        if isMonitoring { return .listening }
        return .idle
    }

    private var alertGlowColor: Color {
        guard let event = viewModel.latestEvent else { return .clear }
        switch event.urgency {
        case .low: return AppColors.alertLow.opacity(0.16)
        case .medium: return AppColors.alertMedium.opacity(0.16)
        case .high: return AppColors.alertHigh.opacity(0.16)
        case .critical: return AppColors.alertCritical.opacity(0.16)
        }
    }

    private var headerColor: Color {
        switch presentationState {
        case .idle:
            AppColors.secondary
        case .calibrating, .listening, .alert, .stopping:
            AppColors.primaryDark
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColors.backgroundPrimary.ignoresSafeArea()

            alertGlowLayer

            helpButton

            helpButton

            Stack(direction: .vertical, align: .center, spacing: 0, width: .fill, height: .fill) {
                Text("ALERTA")
                    .font(AppFont.soraBold(28))
                    .foregroundStyle(headerColor)
                    .tracking(0.38)
                    .padding(.top, topContentPadding)

                mainContent

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, reservedBottomContentHeight)
            .animation(.easeInOut(duration: 0.3), value: viewModel.isRunning)
            .animation(
                .easeInOut(duration: 0.3),
                value: viewModel.latestEvent?.id
            )
            .animation(
                .easeInOut(duration: 0.3),
                value: viewModel.calibrationState
            )
            .animation(.easeInOut(duration: 0.2), value: isStopping)

            bottomContent
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
        }
        .onDisappear {
            stopTransitionTask?.cancel()
        }
        .sheet(isPresented: $isShowingHelpMenuSheet) {
            AwarenessHelpMenuSheet { content in
                presentHelpContent(content)
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .sheet(item: $selectedHelpContent) { content in
            AwarenessHelpDetailView(content: content)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var helpButton: some View {
        VStack {
            HStack {
                Spacer()

                Button {
                    isShowingHelpMenuSheet = true
                } label: {
                    Image(systemName: "questionmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(AppColors.primary)
                        .frame(width: 24, height: 24)
                        .overlay {
                            Circle()
                                .stroke(AppColors.primary, lineWidth: 2)
                        }
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Help")
            }

            Spacer()
        }
        .padding(.top, 16)
        .padding(.horizontal, 28)
    }

    private var alertGlowLayer: some View {
        GeometryReader { geometry in
            if viewModel.latestEvent != nil, alertGlowColor != .clear {
                ZStack(alignment: .topLeading) {
                    Circle()
                        .fill(alertGlowColor)
                        .frame(width: 320, height: 320)
                        .blur(radius: 60)
                        .position(x: -11, y: 351)

                    Circle()
                        .fill(alertGlowColor)
                        .frame(width: 320, height: 320)
                        .blur(radius: 60)
                        .position(x: geometry.size.width + 11, y: 351)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        switch presentationState {
        case .idle:
            idleMainContent
        case .calibrating:
            monitoringMainContent(mode: .monitoring, topPadding: 157)
        case .listening:
            monitoringMainContent(mode: .processing, topPadding: 157)
        case let .alert(event):
            DetectionAlertView(
                event: event,
                isHapticAlertEnabled: viewModel.isHapticAlertEnabled,
                isAudioAlertEnabled: viewModel.isAudioAlertEnabled,
                toggleHapticAlert: viewModel.toggleHapticAlert,
                toggleAudioAlert: viewModel.toggleAudioAlert
            )
            .padding(.top, 90)
            .transition(.scale.combined(with: .opacity))
        case .stopping:
            AudioBarsVisualizer(
                bands: FrequencySpectrum.zero.bands,
                mode: .stopping
            )
            .padding(.top, 171)
        }
    }

    private var idleMainContent: some View {
        Stack(direction: .vertical, align: .center, spacing: 76, width: .fill) {
            AudioBarsVisualizer(
                bands: FrequencySpectrum.zero.bands,
                mode: .idle
            )

            Stack(
                direction: .vertical,
                align: .center,
                spacing: 0,
                width: .fill
            ) {
                Text("Alerta will notify you through these cues.")
                    .font(AppFont.soraRegular(16))
                    .foregroundStyle(AppColors.textSecondary)
                    .tracking(-0.31)
                    .lineSpacing(1)
                    .multilineTextAlignment(.center)
                    .frame(height: 72)
                    .padding(.horizontal, 18)

                HStack(spacing: 6) {
                    CueBadgeView(
                        icon: "iphone.radiowaves.left.and.right",
                        label: "Haptics",
                        style: .labeled,
                        isActive: viewModel.isHapticAlertEnabled,
                        action: viewModel.toggleHapticAlert
                    )
                    CueBadgeView(
                        icon: "airpods.max",
                        label: "Sound",
                        style: .labeled,
                        isActive: viewModel.isAudioAlertEnabled,
                        action: viewModel.toggleAudioAlert
                    )
                }
                .padding(.top, -8)
            }
        }
        .padding(.top, 76)
    }

    private func monitoringMainContent(
        mode: AudioBarsVisualizer.Mode,
        topPadding: CGFloat
    )
        -> some View
    {
        Stack(direction: .vertical, align: .center, spacing: 35, width: .fill) {
            AudioBarsVisualizer(
                bands: viewModel.latestSpectrum.bands,
                mode: mode
            )

            HStack(spacing: 15) {
                CueBadgeView(
                    icon: "iphone.radiowaves.left.and.right",
                    label: "Haptics",
                    style: .compact,
                    isActive: viewModel.isHapticAlertEnabled,
                    action: viewModel.toggleHapticAlert
                )
                CueBadgeView(
                    icon: "airpods.max",
                    label: "Sound",
                    style: .compact,
                    isActive: viewModel.isAudioAlertEnabled,
                    action: viewModel.toggleAudioAlert
                )
            }
            .frame(height: 47)
        }
        .padding(.top, topPadding)
    }

    @ViewBuilder
    private var bottomContent: some View {
        switch presentationState {
        case .idle:
            Stack(
                direction: .vertical,
                align: .center,
                spacing: 16,
                width: .fill
            ) {
                Text(
                    "Alerts may be incorrect, delayed, or not detected at all. "
                        + "Do not rely solely on this app for your safety."
                )
                .font(AppFont.soraRegular(11))
                .foregroundStyle(AppColors.textTertiary)
                .tracking(0.06)
                .lineSpacing(0)
                .multilineTextAlignment(.center)
                .frame(width: 295, height: 28)

                AppButton("Start", systemImage: "play.fill", style: .default) {
                    Task { await viewModel.start() }
                }
                .disabled(!viewModel.canStart)
            }
            .frame(maxWidth: 354)
        case .calibrating, .listening, .alert:
            AppButton("Stop", systemImage: "stop.fill", style: .destructive) {
                stopMonitoring()
            }
            .frame(maxWidth: 354)
        case .stopping:
            EmptyView()
        }
    }

    private var topContentPadding: CGFloat {
        switch presentationState {
        case .idle:
            90
        case .calibrating, .listening, .alert, .stopping:
            76
        }
    }

    private var reservedBottomContentHeight: CGFloat {
        switch presentationState {
        case .idle:
            100
        case .calibrating, .listening, .alert:
            72
        case .stopping:
            0
        }
    }

    private func stopMonitoring() {
        stopTransitionTask?.cancel()
        viewModel.stop()
        isStopping = true

        stopTransitionTask = Task {
            do {
                try await Task.sleep(for: .milliseconds(800))
            } catch is CancellationError {
                return
            } catch {
                assertionFailure(
                    "Unexpected stop transition sleep error: \(error)"
                )
                return
            }

            await MainActor.run {
                isStopping = false
            }
        }
    }

    private func presentHelpContent(_ content: AwarenessHelpContent) {
        isShowingHelpMenuSheet = false

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(200))
            selectedHelpContent = content
        }
    }
}

private enum AwarenessPresentationState {
    case idle
    case calibrating
    case listening
    case alert(DetectionEvent)
    case stopping
}

#Preview("Idle") {
    let container = ModelContainer.appContainer()
    let monitoringConfiguration = AudioMonitoringConfiguration()
    let store = SessionHistoryStore(
        modelContext: container.mainContext,
        detectionCooldown: monitoringConfiguration.detectionCooldown
    )

    NavigationStack {
        AwarenessView(historyStore: store, hapticService: CoreHapticService())
    }
}
