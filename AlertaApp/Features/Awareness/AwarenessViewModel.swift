import Combine
import Foundation
import Observation

@Observable
@MainActor
final class AwarenessViewModel {
    private(set) var isRunning: Bool = false
    private(set) var latestEvent: DetectionEvent?
    private(set) var latestSpectrum: FrequencySpectrum = .zero
    private(set) var latestDirection: SoundDirection = .unknown
    private(set) var baselineProfile: FrequencyProfile?
    private(set) var statusMessage: String = "Ready"
    private(set) var rawDetectedSound: String = "No sound detected yet"
    private(set) var calibrationState: CalibrationState = .notStarted

    var canStart: Bool {
        if isRunning { return false }
        if case .calibrating = calibrationState { return false }
        return true
    }

    private let monitoringService: any AudioMonitoringProviding
    private let permissionProvider: any MicrophonePermissionProviding
    private let feedbackService: CueFeedbackService
    private var cancellables = Set<AnyCancellable>()

    init(
        monitoringService: any AudioMonitoringProviding,
        permissionProvider: any MicrophonePermissionProviding,
        feedbackService: CueFeedbackService
    ) {
        self.monitoringService = monitoringService
        self.permissionProvider = permissionProvider
        self.feedbackService = feedbackService
    }

    func start() async {
        let hasPermission = await permissionProvider.requestPermission()

        guard hasPermission else {
            statusMessage = "Microphone permission is required."
            return
        }

        do {
            try AudioSessionConfigurator().configureSession()

            monitoringService.calibrationPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] state in
                    self?.calibrationState = state
                    switch state {
                    case .calibrating:
                        self?.statusMessage = "Calibrating..."
                    case let .complete(profile):
                        self?.isRunning = true
                        self?.baselineProfile = profile
                        self?.statusMessage = "Listening"
                    case .notStarted:
                        break
                    }
                }
                .store(in: &cancellables)

            try monitoringService.start()

            monitoringService.detectionPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] event in
                    self?.latestEvent = event
                    self?.latestSpectrum = event.frequencyInfo ?? .zero
                    self?.latestDirection = event.direction
                    self?.rawDetectedSound = event.rawIdentifier
                    self?.feedbackService.playHapticCue(for: event)
                }
                .store(in: &cancellables)

            statusMessage = "Calibrating..."
        } catch {
            statusMessage = "Unable to start awareness session."
        }
    }

    func stop() {
        cancellables.removeAll()
        monitoringService.stop()
        isRunning = false
        baselineProfile = nil
        calibrationState = .notStarted
        statusMessage = "Stopped"
    }
}
