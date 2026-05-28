//
//  CoreHapticService.swift
//  AlertaApp
//
//  Created by Kyky on 28/05/26.
//

import CoreHaptics
import Foundation

struct HapticPatternConfig {
    let events: [CHHapticEvent]
}

class CoreHapticsService: HapticFeedbackProviding {
    private var engine: CHHapticEngine?
    private var isMonitoring: Bool = false

    private let patternMap: [AlertUrgency: HapticPatternConfig]

    init(patternMap: [AlertUrgency: HapticPatternConfig]) {
        self.patternMap = patternMap
        setupEngine()
    }

    private func setupEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()

            engine?.stoppedHandler = { [weak self] reason in
                print("Haptic engine stopped: \(reason)")
                if self?.isMonitoring == true {
                    try? self?.engine?.start()
                }
            }

            engine?.resetHandler = { [weak self] in
                print("Haptic engine reset")
                try? self?.engine?.start()
            }

        } catch {
            print(AppError.hapticEngineCreationFails(error.localizedDescription))
        }
    }

    func prepare() {
        isMonitoring = true
        do {
            try engine?.start()
        } catch {
            print(AppError.hapticEngineStartFails(error.localizedDescription))
        }
    }

    func playHaptic(for urgency: AlertUrgency) {
        guard isMonitoring, let engine else { return }
        guard let config = patternMap[urgency] else { return }

        do {
            let pattern = try CHHapticPattern(events: config.events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print(AppError.hapticPlaybackFails(error.localizedDescription))
        }
    }

    func stop() {
        isMonitoring = false
        engine?.stop(completionHandler: nil)
    }
}
