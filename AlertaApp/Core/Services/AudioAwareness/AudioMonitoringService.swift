import AVFoundation
import Combine
import Foundation
import os
import SoundAnalysis

struct AudioMonitoringConfiguration {
    var windowDuration: CMTime = CMTime(seconds: 1.5, preferredTimescale: 48_000)
    var overlapFactor: Double = 0.5
    var minimumSpecificConfidence: Float = 0.12
    var minimumFallbackConfidence: Float = 0.25
    var bufferSize: AVAudioFrameCount = 8192
    var directionThreshold: Float = 0.02
}

final class AudioMonitoringService: NSObject, AudioMonitoringProviding {
    private let audioEngine: AVAudioEngine
    private let configuration: AudioMonitoringConfiguration
    private let directionEstimator = DirectionEstimator()

    private var soundClassifier: SoundAnalysisClassifier?
    private let subject = PassthroughSubject<DetectionEvent, Never>()

    private let directionState = OSAllocatedUnfairLock<SoundDirection>(initialState: .nearby)

    private(set) var isRunning: Bool = false

    var detectionPublisher: AnyPublisher<DetectionEvent, Never> {
        subject.eraseToAnyPublisher()
    }

    init(audioEngine: AVAudioEngine = AVAudioEngine(),
         configuration: AudioMonitoringConfiguration = AudioMonitoringConfiguration())
    {
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

            let direction = self.directionState.withLock { $0 }

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
                timestamp: Date()
            )

            self.subject.send(event)
        }

        inputNode.removeTap(onBus: 0)

        inputNode.installTap(
            onBus: 0,
            bufferSize: configuration.bufferSize,
            format: inputFormat
        ) { [weak self] buffer, time in
            guard let self else { return }

            let direction = self.directionEstimator.estimateDirection(
                from: buffer,
                threshold: self.configuration.directionThreshold
            )
            self.directionState.withLock { $0 = (direction == .unknown ? .nearby : direction) }

            self.soundClassifier?.analyze(buffer: buffer, at: time)
        }

        audioEngine.prepare()
        try audioEngine.start()
        isRunning = true
    }

    func stop() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        soundClassifier = nil
        isRunning = false
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
