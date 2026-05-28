//
//  HapticPatternConfig.swift
//  AlertaApp
//
//  Created by Kyky on 28/05/26.
//


import Foundation
import CoreHaptics

struct HapticPatternConfig {
    let events: [CHHapticEvent]
}

class CoreHapticsService: HapticFeedbackProviding {
    private var engine: CHHapticEngine?
    private var isMonitoring: Bool = false
    
    // Konfigurasi pola getaran disuntikkan dari luar (tidak hardcode di dalam service)
    private let patternMap: [AlertUrgency: HapticPatternConfig]
    
    init(patternMap: [AlertUrgency: HapticPatternConfig]) {
        self.patternMap = patternMap
        setupEngine()
    }
    
    private func setupEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            
            // Handle Interruption (Misal: ada telepon masuk) -> AC Tiket
            engine?.stoppedHandler = { [weak self] reason in
                print("Haptic engine stopped: \(reason)")
                // Coba nyalakan lagi kalau sesinya masih aktif
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
            // Keep engine warm untuk menghilangkan delay/latency -> AC Tiket
            try engine?.start()
        } catch {
            print(AppError.hapticEngineStartFails(error.localizedDescription))
        }
    }
    
    func playHaptic(for urgency: AlertUrgency) {
        // Jangan bergetar jika monitoring stop atau engine mati
        guard isMonitoring, let engine = engine else { return }
        guard let config = patternMap[urgency] else { return }
        
        do {
            let pattern = try CHHapticPattern(events: config.events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0) // No delay
        } catch {
            print(AppError.hapticPlaybackFails(error.localizedDescription))
        }
    }
    
    func stop() {
        isMonitoring = false
        engine?.stop(completionHandler: nil)
    }
}
