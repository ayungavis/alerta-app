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
    private(set) var latestOutputError: AppError?
    private(set) var isHapticAlertEnabled: Bool = true
    private(set) var isAudioAlertEnabled: Bool = true

    var canStart: Bool {
        if isRunning { return false }
        if case .calibrating = calibrationState { return false }
        return true
    }

    private let monitoringService: any AudioMonitoringProviding
    private let permissionProvider: any MicrophonePermissionProviding
    private let audioOutputService: any AudioOutputProviding
    private var cancellables = Set<AnyCancellable>()
    private let hapticService: HapticFeedbackProviding
    private var detectionDebounceTask: Task<Void, Never>?

    init(
        monitoringService: any AudioMonitoringProviding,
        permissionProvider: any MicrophonePermissionProviding,
        audioOutputService: any AudioOutputProviding,
        hapticService: HapticFeedbackProviding
    ) {
        self.monitoringService = monitoringService
        self.permissionProvider = permissionProvider
        self.audioOutputService = audioOutputService
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
                    case let .complete(profile):
                        self?.isRunning = true
                        self?.baselineProfile = profile
                    case .notStarted:
                        break
                    }
                }
                .store(in: &cancellables)

            try monitoringService.start()
            hapticService.prepare()

            monitoringService.detectionPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] event in
                    guard let self else { return }
                    detectionDebounceTask?.cancel()

                    latestEvent = event
                    latestSpectrum = event.frequencyInfo ?? .zero
                    latestDirection = event.direction
                    rawDetectedSound = event.rawIdentifier
                    playEnabledFeedback(for: event)

                    detectionDebounceTask = Task {
                        try? await Task.sleep(for: .seconds(4))
                        guard !Task.isCancelled else { return }
                        self.latestEvent = nil
                        self.latestSpectrum = .zero
                        self.latestDirection = .unknown
                        self.rawDetectedSound = "No sound detected yet"
                    }
                }
                .store(in: &cancellables)
        } catch {}
    }

    func stop() {
        detectionDebounceTask?.cancel()
        cancellables.removeAll()
        monitoringService.stop()
        hapticService.stop()
        audioOutputService.stopSpeaking()
        isRunning = false
        baselineProfile = nil
        calibrationState = .notStarted
        latestEvent = nil
        latestSpectrum = .zero
    }

    func toggleHapticAlert() {
        isHapticAlertEnabled.toggle()
    }

    func toggleAudioAlert() {
        isAudioAlertEnabled.toggle()
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

    private func playEnabledFeedback(for event: DetectionEvent) {
        if isHapticAlertEnabled {
            hapticService.playHaptic(for: event.urgency)
        }

        guard isAudioAlertEnabled else { return }

        do {
            try audioOutputService.play(event)
            latestOutputError = nil
        } catch let appError as AppError {
            latestOutputError = appError
            assertionFailure(outputErrorMessage(for: event, error: appError))
        } catch {
            let appError = AppError.audioOutput(.sessionActivationFailed(underlying: error))
            latestOutputError = appError
            assertionFailure(outputErrorMessage(for: event, error: appError))
        }
    }

    private func outputErrorMessage(for event: DetectionEvent, error: AppError) -> String {
        "Audio output failed for soundEvent=\(event.soundEvent.rawValue), " +
            "urgency=\(event.urgency.displayName), rawIdentifier=\(event.rawIdentifier), " +
            "error=\(error.localizedDescription)"
    }
}
