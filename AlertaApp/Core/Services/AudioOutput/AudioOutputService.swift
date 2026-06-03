//
//  AudioOutputService.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 03/06/26.
//


//
//  AudioOutputService.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 28/05/26.
//

import AudioToolbox
import AVFoundation

/// Concrete audio output service.
/// Uses `AudioServicesPlaySystemSound` for brief chime feedback and `AVSpeechSynthesizer` for TTS announcements.
/// - No SwiftUI imports — safe to instantiate in any layer.
/// - Marked `final` so the compiler can devirtualise calls.
final class AudioOutputService: NSObject {
    private let synthesiser: AVSpeechSynthesizer
    private let utteranceBuilder: SpeechUtteranceBuilder

    private(set) var isSpeaking: Bool = false

    init(
        synthesiser: AVSpeechSynthesizer = AVSpeechSynthesizer(),
        utteranceBuilder: SpeechUtteranceBuilder = SpeechUtteranceBuilder()
    ) {
        self.synthesiser = synthesiser
        self.utteranceBuilder = utteranceBuilder
        super.init()
        self.synthesiser.delegate = self
    }

    func play(_ event: DetectionEvent) throws {
        try activateAudioSession()
        playSystemSound(for: event)
        speak(event)
    }

    func stopSpeaking() {
        synthesiser.stopSpeaking(at: .immediate)
    }

    private func activateAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        do {
            // `.playback` keeps audio alive when the ringer switch is muted.
            try session.setCategory(
                .playback,
                mode: .spokenAudio,
                options: .duckOthers
            )
            try session.setActive(true)
        } catch {
            throw AppError.audioOutput(
                .sessionActivationFailed(underlying: error)
            )
        }
    }

    private func playSystemSound(for event: DetectionEvent) {
        let soundID = SystemSoundID.id(for: event.urgency)
        AudioServicesPlaySystemSound(soundID)
    }

    private func speak(_ event: DetectionEvent) {
        if synthesiser.isSpeaking {
            synthesiser.stopSpeaking(at: .immediate)
        }
        let utterance = utteranceBuilder.build(from: event)
        synthesiser.speak(utterance)
    }
}

extension AudioOutputService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(
        _ synthesiser: AVSpeechSynthesizer,
        didStart utterance: AVSpeechUtterance
    ) {
        isSpeaking = true
    }

    func speechSynthesizer(
        _ synthesiser: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        isSpeaking = false
    }

    func speechSynthesizer(
        _ synthesiser: AVSpeechSynthesizer,
        didCancel utterance: AVSpeechUtterance
    ) {
        isSpeaking = false
    }
}

private extension SystemSoundID {
    /// Maps urgency levels to built-in system sound IDs.
    /// IDs sourced from the iOS System Sound library (uidialog subset).
    static func id(for urgency: Urgency) -> SystemSoundID {
        switch urgency {
        case .critical: 1005 // SIMToolkitNegativeACK — sharp, attention-grabbing
        case .high: 1003 // SIMToolkitPositiveACK — firm double-tap feel
        case .medium: 1016 // tweet — neutral mid-priority chime
        case .low: 1519 // Tock — subtle, non-disruptive
        }
    }
}
