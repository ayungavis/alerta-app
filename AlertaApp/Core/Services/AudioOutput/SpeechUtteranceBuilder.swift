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
            return "Warning. \(event.label) detected immediately ahead."
        case .high:
            return "\(event.label) detected ahead."
        case .medium:
            return "\(event.label) nearby."
        case .low:
            return event.label
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

    private func speechRate(for urgency: AlertUrgency) -> Float {
        switch urgency {
        case .critical: return AVSpeechUtteranceDefaultSpeechRate
        case .high: return AVSpeechUtteranceDefaultSpeechRate
        case .medium: return AVSpeechUtteranceDefaultSpeechRate
        case .low: return AVSpeechUtteranceDefaultSpeechRate
        }
    }

    private func pitchMultiplier(for urgency: AlertUrgency) -> Float {
        switch urgency {
        case .critical: return 1.3
        case .high: return 1.15
        case .medium: return 1.0
        case .low: return 0.9
        }
    }

    private func preDelay(for urgency: AlertUrgency) -> TimeInterval {
        switch urgency {
        case .critical: return 0.05
        case .high: return 0.10
        case .medium: return 0.15
        case .low: return 0.20
        }
    }
}
