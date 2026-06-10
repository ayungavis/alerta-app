//
//  SessionEvent.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 08/06/26.
//

import Foundation

struct SessionEvent: Identifiable {
    let id: UUID
    let name: String
    let start: Date
    let end: Date
    let events: [DetectionEvent]
}
