//
//  AudioOutputService.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 03/06/26.
//

import AudioToolbox
import AVFoundation

// Concrete audio output service.
// Uses `AudioServicesPlaySystemSound` for brief chime feedback and `AVSpeechSynthesizer` for TTS announcements.
// - No SwiftUI imports — safe to instantiate in any layer.
// - Marked `final` so the compiler can devirtualise calls.

final class AudioOutputService: NSObject, AudioOutputProviding {
    private let synthesiser: AVSpeechSynthesizer
    private let utteranceBuilder: SpeechUtteranceBuilder
    private var isSessionActive = false

    private let cooldown: TimeInterval // seconds
    private var lastPlayedAt: [Urgency: Date]

    private(set) var isSpeaking: Bool = false

    init(
        synthesiser: AVSpeechSynthesizer = AVSpeechSynthesizer(),
        utteranceBuilder: SpeechUtteranceBuilder = SpeechUtteranceBuilder(),
        cooldown: TimeInterval = 10.0,
        lastPlayedAt: [Urgency: Date] = [:]
    ) {
        self.synthesiser = synthesiser
        self.utteranceBuilder = utteranceBuilder
        self.cooldown = cooldown
        self.lastPlayedAt = lastPlayedAt
        super.init()
        self.synthesiser.delegate = self
    }

    func play(_ event: DetectionEvent) throws {
        try activateAudioSession()

        print("Session category: \(AVAudioSession.sharedInstance().category)")
        print("Session mode: \(AVAudioSession.sharedInstance().mode)")

        // Skip if same urgency played within cooldown window
        if let lastPlayed = lastPlayedAt[event.urgency],
           Date().timeIntervalSince(lastPlayed) < cooldown
        {
            return
        }

        lastPlayedAt[event.urgency] = Date()
        playSystemSound(for: event)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.speak(event)
        }
    }

    private func playSystemSound(for event: DetectionEvent) {
        AudioServicesPlaySystemSound(SystemSoundID.id(for: event.urgency))
    }

//    private func speak(_ event: DetectionEvent) {
//        let utterance = utteranceBuilder.build(from: event)
//        synthesiser.speak(utterance) // must be on main thread
//    }

    private func speak(_ event: DetectionEvent) {
        let utterance = utteranceBuilder.build(from: event)

        let savedSpeed = UserDefaults.standard.object(forKey: "voiceSpeed") as? Float ?? 0.5
        print("Using speech rate: \(savedSpeed)")
        let savedVolume = UserDefaults.standard.object(forKey: "voiceVolume") as? Float ?? 1.0
        print("Using speech rate: \(savedSpeed)")

        utterance.rate = savedSpeed
        utterance.volume = savedVolume

        synthesiser.speak(utterance)
    }

    func stopSpeaking() {
        synthesiser.stopSpeaking(at: .immediate)
    }

    private func activateAudioSession() throws {
        guard !isSessionActive else { return }
        let session = AVAudioSession.sharedInstance()

        if session.category == .playAndRecord {
            isSessionActive = true
            return
        }

        do {
            try session.setCategory(
                .playAndRecord,
                mode: .spokenAudio,
                options: [.duckOthers, .defaultToSpeaker]
            )
            try session.setAllowHapticsAndSystemSoundsDuringRecording(true)
            try session.setActive(true)
            isSessionActive = true
        } catch {
            throw AppError.audioOutput(
                .sessionActivationFailed(underlying: error)
            )
        }
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

    func playTestVoice(speed: Float, volume: Float) {
        let testUtterance = AVSpeechUtterance(string: "This is how I will sound.")
        testUtterance.rate = speed
        testUtterance.volume = volume
        testUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        synthesiser.speak(testUtterance)
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
