//
//  AwarenessViewModel.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

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
    private let hapticService: HapticFeedbackProviding

    init(
        monitoringService: any AudioMonitoringProviding,
        permissionProvider: any MicrophonePermissionProviding,
        feedbackService: CueFeedbackService,
        hapticService: HapticFeedbackProviding
    ) {
        self.monitoringService = monitoringService
        self.permissionProvider = permissionProvider
        self.feedbackService = feedbackService
        self.hapticService = hapticService
    }

    func start() async {
        let hasPermission = await permissionProvider.requestPermission()

        guard hasPermission else {
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
                        break
                    case .complete(let profile):
                        self?.isRunning = true
                        self?.baselineProfile = profile
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
        } catch {}
    }

    func stop() {
        cancellables.removeAll()
        monitoringService.stop()
        isRunning = false
        baselineProfile = nil
        calibrationState = .notStarted
    }

    func onDetectionEventReceived(_ event: DetectionEvent) {
        hapticService.playHaptic(for: event.urgency)
    }

    func startSession() {
        hapticService.prepare()
    }

    func stopSession() {
        hapticService.stop()
    }
}
