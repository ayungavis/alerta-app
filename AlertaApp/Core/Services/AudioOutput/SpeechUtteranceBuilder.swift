//
//  SpeechUtteranceBuilder.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 03/06/26.
//

//
//  SpeechUtteranceBuilder.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 28/05/26.
//

import AVFoundation

/// Pure, stateless factory that constructs an `AVSpeechUtterance` from a `DetectionEvent`.
/// Deliberately has zero service dependencies so it can be unit-tested without any mocking infrastructure.
struct SpeechUtteranceBuilder {
    /// Builds a fully configured utterance ready to be handed to `AVSpeechSynthesizer.speak(_:)`.
    func build(from event: DetectionEvent) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: announcementText(for: event))
        utterance.voice = preferredVoice()
        utterance.rate = speechRate(for: event.urgency)
        utterance.pitchMultiplier = pitchMultiplier(for: event.urgency)
        utterance.volume = 1.0
        // Pre-utterance delay prevents the chime and voice from overlapping.
        utterance.preUtteranceDelay = preDelay(for: event.urgency)
        return utterance
    }

    private func announcementText(for event: DetectionEvent) -> String {
        switch event.urgency {
        case .critical:
            "Warning. \(event.soundEvent.dispalyName) detected immediately ahead."
        case .high:
            "\(event.soundEvent.dispalyName) detected ahead."
        case .medium:
            "\(event.soundEvent.dispalyName) nearby."
        case .low:
            event.soundEvent.dispalyName
        }
    }

    /// Prefers an enhanced-quality voice for the device locale, falls back to the system default if none is installed.
    private func preferredVoice() -> AVSpeechSynthesisVoice? {
        let languageCode =
            Locale.current.language.languageCode?.identifier ?? "en"
        return AVSpeechSynthesisVoice.speechVoices()
            .filter {
                $0.language.hasPrefix(languageCode) && $0.quality == .enhanced
            }
            .first
            ?? AVSpeechSynthesisVoice(language: languageCode)
    }

    private func speechRate(for urgency: Urgency) -> Float {
        switch urgency {
        case .critical: AVSpeechUtteranceDefaultSpeechRate
        case .high: AVSpeechUtteranceDefaultSpeechRate
        case .medium: AVSpeechUtteranceDefaultSpeechRate
        case .low: AVSpeechUtteranceDefaultSpeechRate
        }
    }

    private func pitchMultiplier(for urgency: Urgency) -> Float {
        switch urgency {
        case .critical: 1.3
        case .high: 1.15
        case .medium: 1.0
        case .low: 0.9
        }
    }

    private func preDelay(for urgency: Urgency) -> TimeInterval {
        switch urgency {
        case .critical: 0.05
        case .high: 0.10
        case .medium: 0.15
        case .low: 0.20
        }
    }
}
