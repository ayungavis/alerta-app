//
//  AwarenessAlertRecord.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 08/06/26.
//

import Foundation

struct AwarenessAlertRecord: Identifiable, Codable, Equatable {
    let id: UUID
    let sessionId: UUID
    let soundEvent: SoundEvent
    let urgency: Urgency
    let direction: SoundDirection
    let confidence: Float
    let rawIdentifier: String
    let timestamp: Date
    let soundName: String?
    let soundLevelDecibels: Float?
}
