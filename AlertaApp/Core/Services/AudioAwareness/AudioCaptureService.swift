//
//  AudioCaptureService.swift
//  ExprimentApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import AVFoundation
import Foundation

final class AudioCaptureService {
    private let audioEngine: AVAudioEngine
    private let directionEstimator: DirectionEstimator
    private var soundClassifier: SoundAnalysisClassifier?

    init(audioEngine: AVAudioEngine, directionEstimator: DirectionEstimator) {
        self.audioEngine = audioEngine
        self.directionEstimator = directionEstimator
    }

    func start(onDetection: @escaping (DetectionEvent) -> Void) throws {
        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)

        soundClassifier = try SoundAnalysisClassifier(format: inputFormat) { match in
            let direction = SoundDirection.nearby

            let candidates = match.topCandidates.map {
                DetectionCandidate(identifier: $0.identifier, confidence: $0.confidence)
            }

            let event = DetectionEvent(
                id: UUID(),
                soundEvent: match.event,
                direction: direction,
                confidence: match.confidence,
                urgency: match.event.urgency,
                topCandidates: candidates,
                rawIdentifier: match.rawIdentifier,
                timestamp: Date(),
                frequencyInfo: nil
            )

            onDetection(event)
        }

        inputNode.removeTap(onBus: 0)

        inputNode.installTap(
            onBus: 0,
            bufferSize: 8192,
            format: inputFormat
        ) { [weak self] buffer, time in
            self?.soundClassifier?.analyze(buffer: buffer, at: time)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }

    func stop() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        soundClassifier = nil
    }
}
