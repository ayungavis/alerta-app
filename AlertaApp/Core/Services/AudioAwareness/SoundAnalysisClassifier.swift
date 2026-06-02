//
//  SoundAnalysisClassifier.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 21/05/26.
//

import AVFoundation
import SoundAnalysis

struct SoundClassificationCandidate {
    let identifier: String
    let confidence: Float
}

struct SoundClassificationMatch {
    let event: SoundEvent
    let confidence: Float
    let rawIdentifier: String
    let topCandidates: [SoundClassificationCandidate]
}

final class SoundAnalysisClassifier: NSObject, SNResultsObserving {
    private let analyzer: SNAudioStreamAnalyzer
    private let request: SNClassifySoundRequest
    private let analysisQueue: DispatchQueue
    private let configuration: AudioMonitoringConfiguration
    private let onResult: (SoundClassificationMatch) -> Void

    init(
        format: AVAudioFormat,
        configuration: AudioMonitoringConfiguration = AudioMonitoringConfiguration(),
        onResult: @escaping (SoundClassificationMatch) -> Void
    ) throws {
        analyzer = SNAudioStreamAnalyzer(format: format)
        request = try SNClassifySoundRequest(classifierIdentifier: .version1)
        analysisQueue = DispatchQueue(label: "sound-analysis-classifier")
        self.configuration = configuration
        self.onResult = onResult
        super.init()

        request.windowDuration = configuration.windowDuration
        request.overlapFactor = configuration.overlapFactor

        try analyzer.add(request, withObserver: self)

        print("Known SoundAnalysis labels:")
        print(request.knownClassifications.sorted().joined(separator: "\n"))
    }

    func analyze(buffer: AVAudioPCMBuffer, at time: AVAudioTime) {
        analysisQueue.async { [analyzer] in
            analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
        }
    }

    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else {
            return
        }

        let candidates = result.classifications.prefix(8).map { classification in
            SoundClassificationCandidate(
                identifier: classification.identifier,
                confidence: Float(classification.confidence)
            )
        }

        let debugText =
            candidates
                .map { "\($0.identifier): \(Int($0.confidence * 100))%" }
                .joined(separator: " | ")

        print("Top sound candidates:", debugText)

        guard let match = mapCandidatesToEvent(candidates) else {
            return
        }

        onResult(match)
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Sound analysis failed:", error.localizedDescription)
    }

    func requestDidComplete(_ request: SNRequest) {
        print("Sound analysis completed")
    }

    private func mapCandidatesToEvent(_ candidates: [SoundClassificationCandidate])
        -> SoundClassificationMatch?
    {
        let minimumSpecificConfidence = configuration.minimumSpecificConfidence
        let minimumFallbackConfidence = configuration.minimumFallbackConfidence

        for candidate in candidates where candidate.confidence >= minimumSpecificConfidence {
            if let event = mapIdentifierToSpecificEvent(candidate.identifier) {
                return SoundClassificationMatch(
                    event: event,
                    confidence: candidate.confidence,
                    rawIdentifier: candidate.identifier,
                    topCandidates: candidates
                )
            }
        }

        guard let strongestCandidate = candidates.first,
              strongestCandidate.confidence >= minimumFallbackConfidence,
              isGeneralAwarenessSound(strongestCandidate.identifier)
        else {
            return nil
        }

        return SoundClassificationMatch(
            event: .generalLoudSound,
            confidence: strongestCandidate.confidence,
            rawIdentifier: strongestCandidate.identifier,
            topCandidates: candidates
        )
    }

    private func mapIdentifierToSpecificEvent(_ identifier: String) -> SoundEvent? {
        let label = normalizedLabel(identifier)

        if containsAny(
            label,
            keywords: ["siren", "emergency vehicle", "ambulance", "police car", "fire engine"]
        ) {
            return .siren
        }

        if containsAny(
            label, keywords: ["horn", "honking", "vehicle horn", "car horn", "air horn"]
        ) {
            return .horn
        }

        if containsAny(
            label,
            keywords: [
                "car", "truck", "bus", "vehicle", "motorcycle", "motor vehicle", "engine",
                "traffic"
            ]
        ) {
            return .approachingVehicle
        }

        if containsAny(
            label, keywords: ["bicycle", "bike", "scooter", "bicycle bell", "skateboard"]
        ) {
            return .bicycleOrScooter
        }

        if containsAny(
            label, keywords: ["footstep", "walking", "running", "person", "speech", "crowd"]
        ) {
            return .nearbyPersonMovement
        }

        return nil
    }

    private func isGeneralAwarenessSound(_ identifier: String) -> Bool {
        let label = normalizedLabel(identifier)

        return containsAny(
            label,
            keywords: [
                "noise", "sound", "bang", "slam", "thump", "crash", "explosion", "outside", "urban"
            ]
        )
    }

    private func normalizedLabel(_ identifier: String) -> String {
        identifier
            .lowercased()
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
    }

    private func containsAny(_ label: String, keywords: [String]) -> Bool {
        keywords.contains { keyword in
            label.contains(keyword)
        }
    }
}
