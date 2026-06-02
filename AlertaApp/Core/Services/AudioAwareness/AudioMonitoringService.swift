//
//  AudioMonitoringService.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import AVFoundation
import Combine
import CoreMotion
import Foundation
import os
import SoundAnalysis

struct AudioMonitoringConfiguration {
    var windowDuration: CMTime = .init(seconds: 1.5, preferredTimescale: 48000)
    var overlapFactor: Double = 0.5
    var minimumSpecificConfidence: Float = 0.12
    var minimumFallbackConfidence: Float = 0.25
    var bufferSize: AVAudioFrameCount = 8192
    var directionThreshold: Float = 0.02
    var calibrationDuration: TimeInterval = 3.0
}

final class AudioMonitoringService: NSObject, AudioMonitoringProviding {
    private let audioEngine: AVAudioEngine
    private let configuration: AudioMonitoringConfiguration
    private let directionEstimator = DirectionEstimator()
    private let frequencyAnalyzer = FrequencyAnalyzer()

    private let headphoneMotionProvider = HeadphoneMotionProvider()
    private var headYaw: Double?
    private var headYawCancellable: AnyCancellable?

    private var soundClassifier: SoundAnalysisClassifier?
    private let subject = PassthroughSubject<DetectionEvent, Never>()
    private let calibrationSubject = PassthroughSubject<CalibrationState, Never>()

    private let directionState = OSAllocatedUnfairLock<SoundDirection>(initialState: .nearby)
    private let frequencyState = OSAllocatedUnfairLock<FrequencySpectrum>(initialState: .zero)
    private var calibrationBuffers: [AVAudioPCMBuffer] = []
    private var isCalibrating = false

    private(set) var isRunning: Bool = false

    var detectionPublisher: AnyPublisher<DetectionEvent, Never> {
        subject.eraseToAnyPublisher()
    }

    var calibrationPublisher: AnyPublisher<CalibrationState, Never> {
        calibrationSubject.eraseToAnyPublisher()
    }

    init(
        audioEngine: AVAudioEngine = AVAudioEngine(),
        configuration: AudioMonitoringConfiguration = AudioMonitoringConfiguration()
    ) {
        self.audioEngine = audioEngine
        self.configuration = configuration
        super.init()
        observeInterruptions()
    }

    func start() throws {
        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)

        soundClassifier = try SoundAnalysisClassifier(
            format: inputFormat,
            configuration: configuration
        ) { [weak self] match in
            guard let self else { return }

            let direction = directionState.withLock { $0 }
            let frequencyInfo = frequencyState.withLock { $0 }

            let detectionCandidates = match.topCandidates.map {
                DetectionCandidate(identifier: $0.identifier, confidence: $0.confidence)
            }

            let event = DetectionEvent(
                id: UUID(),
                soundEvent: match.event,
                direction: direction,
                confidence: match.confidence,
                urgency: match.event.urgency,
                topCandidates: detectionCandidates,
                rawIdentifier: match.rawIdentifier,
                timestamp: Date(),
                frequencyInfo: frequencyInfo
            )

            subject.send(event)
        }

        if AudioSessionConfigurator().isAirPodsConnected() {
            startHeadphoneMotion()
        }

        inputNode.removeTap(onBus: 0)

        inputNode.installTap(
            onBus: 0,
            bufferSize: configuration.bufferSize,
            format: inputFormat
        ) { [weak self] buffer, _ in
            guard let self else { return }

            if isCalibrating {
                calibrationBuffers.append(buffer)
                return
            }

            let yaw = headYaw
            let direction = directionEstimator.estimateDirection(
                from: buffer,
                threshold: configuration.directionThreshold,
                headYaw: yaw
            )
            directionState.withLock { $0 = (direction == .unknown ? .nearby : direction) }

            let spectrum = frequencyAnalyzer.analyze(buffer: buffer)
            frequencyState.withLock { $0 = spectrum }

            soundClassifier?.analyze(buffer: buffer, at: .init(hostTime: mach_absolute_time()))
        }

        audioEngine.prepare()
        try audioEngine.start()

        startCalibration()
    }

    func stop() {
        headphoneMotionProvider.stop()
        headYawCancellable?.cancel()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        soundClassifier = nil
        isRunning = false
        isCalibrating = false
        calibrationBuffers.removeAll()
    }

    private func startCalibration() {
        isCalibrating = true
        calibrationSubject.send(.calibrating)

        DispatchQueue.main.asyncAfter(deadline: .now() + configuration.calibrationDuration) { [weak self] in
            guard let self, isCalibrating else { return }

            let profile = frequencyAnalyzer.captureBaseline(from: calibrationBuffers)
            calibrationBuffers.removeAll()
            isCalibrating = false
            isRunning = true
            calibrationSubject.send(.complete(profile))
        }
    }

    private func startHeadphoneMotion() {
        guard headphoneMotionProvider.isAvailable else { return }

        headYawCancellable = headphoneMotionProvider.yawPublisher
            .sink { [weak self] yaw in
                self?.headYaw = yaw
            }

        headphoneMotionProvider.start()
    }

    private func observeInterruptions() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
    }

    @objc private func handleInterruption(_ notification: Notification) {
        guard let typeValue = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue)
        else { return }

        switch type {
        case .began:
            let wasRunning = isRunning
            stop()
            isRunning = wasRunning

        case .ended:
            guard isRunning,
                  let optionsValue = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt
            else { return }

            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                try? start()
            }

        @unknown default:
            break
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
