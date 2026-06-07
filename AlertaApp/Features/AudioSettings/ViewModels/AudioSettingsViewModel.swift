//
//  AudioSettingsViewModel.swift
//  AlertaApp
//

import Foundation
import Observation

@Observable
class AudioSettingsViewModel {
    // Range volume standar Apple: 0.0 sampai 1.0
    var voiceVolume: Float {
        didSet { UserDefaults.standard.set(voiceVolume, forKey: "voiceVolume") }
    }
    
    // Range kecepatan standar Apple: 0.0 sampai 1.0 (0.5 adalah normal)
    var voiceSpeed: Float {
        didSet { UserDefaults.standard.set(voiceSpeed, forKey: "voiceSpeed") }
    }
    
    init() {
        // Tarik data lama saat aplikasi dibuka, beri nilai default jika masih kosong
        self.voiceVolume = UserDefaults.standard.object(forKey: "voiceVolume") as? Float ?? 1.0
        self.voiceSpeed = UserDefaults.standard.object(forKey: "voiceSpeed") as? Float ?? 0.5
    }
}