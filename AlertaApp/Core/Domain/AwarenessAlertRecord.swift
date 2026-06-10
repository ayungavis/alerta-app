//
//  AwarenessAlertRecord.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 08/06/26.
//

import Foundation
import SwiftData

@Model
final class AwarenessAlertRecord {
    var id: UUID
    var sessionId: UUID
    var soundEvent: SoundEvent
    var urgency: Urgency
    var direction: SoundDirection
    var confidence: Float
    var rawIdentifier: String
    var timestamp: Date
    var soundName: String?
    var soundLevelDecibels: Float?

    init(id: UUID = UUID(), sessionId: UUID, soundEvent: SoundEvent, urgency: Urgency, direction: SoundDirection, confidence: Float, rawIdentifier: String, timestamp: Date, soundName: String? = nil, soundLevelDecibels: Float? = nil) {
        self.id = id
        self.sessionId = sessionId
        self.soundEvent = soundEvent
        self.urgency = urgency
        self.direction = direction
        self.confidence = confidence
        self.rawIdentifier = rawIdentifier
        self.timestamp = timestamp
        self.soundName = soundName
        self.soundLevelDecibels = soundLevelDecibels
    }
}
