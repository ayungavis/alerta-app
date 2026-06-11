//
//  AudioSettingsViewModel.swift
//  AlertaApp
//

import Foundation
import SwiftData

@Observable
@MainActor
class AudioSettingsViewModel {
    var voiceVolume: Float {
        didSet {
            settingsRecord?.voiceVolume = voiceVolume
            UserDefaults.standard.set(voiceVolume, forKey: "voiceVolume")
            save()
        }
    }

    var voiceSpeed: Float {
        didSet {
            settingsRecord?.voiceSpeed = voiceSpeed
            UserDefaults.standard.set(voiceSpeed, forKey: "voiceSpeed")
            save()
        }
    }

    private let modelContext: ModelContext
    private var settingsRecord: UserSettingsModel?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext

        // Defaults — will be overwritten by loadSettings()
        voiceVolume = 1.0
        voiceSpeed = 0.5
        loadSettings()
    }

    private func loadSettings() {
        let descriptor = FetchDescriptor<UserSettingsModel>()
        let records = try? modelContext.fetch(descriptor)

        if let record = records?.first {
            settingsRecord = record
            voiceVolume = record.voiceVolume
            voiceSpeed = record.voiceSpeed
        } else {
            // First launch — create the record with defaults
            let newRecord = UserSettingsModel()
            modelContext.insert(newRecord)
            settingsRecord = newRecord
            voiceVolume = newRecord.voiceVolume
            voiceSpeed = newRecord.voiceSpeed
            save()
        }

        // Keep UserDefaults in sync so AudioOutputService picks them up
        UserDefaults.standard.set(voiceVolume, forKey: "voiceVolume")
        UserDefaults.standard.set(voiceSpeed, forKey: "voiceSpeed")
    }

    private func save() {
        try? modelContext.save()
    }
}
