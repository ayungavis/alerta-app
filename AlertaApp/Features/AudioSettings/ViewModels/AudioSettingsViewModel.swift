//
//  AudioSettingsViewModel.swift
//  AlertaApp
//
//  Created by Kyky on 07/06/26.
//

import Foundation
import Observation

@Observable
class AudioSettingsViewModel {
    var voiceVolume: Float {
        didSet { UserDefaults.standard.set(voiceVolume, forKey: "voiceVolume") }
    }

    var voiceSpeed: Float {
        didSet { UserDefaults.standard.set(voiceSpeed, forKey: "voiceSpeed") }
    }

    init() {
        voiceVolume = UserDefaults.standard.object(forKey: "voiceVolume") as? Float ?? 1.0
        voiceSpeed = UserDefaults.standard.object(forKey: "voiceSpeed") as? Float ?? 0.5
    }
}
