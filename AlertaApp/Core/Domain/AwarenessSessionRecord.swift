//
//  AwarenessSessionRecord.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 08/06/26.
//

import Foundation

struct AwarenessSessionRecord: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let startedAt: Date
    var endedAt: Date?
    var alerts: [AwarenessAlertRecord]

    var isLive: Bool {
        endedAt == nil
    }

    var alertCount: Int {
        alerts.count
    }

    var duration: TimeInterval {
        let effectiveEndDate: Date = endedAt ?? Date()
        return max(effectiveEndDate.timeIntervalSince(startedAt), 0)
    }

    func alertCount(for urgency: Urgency) -> Int {
        alerts.filter { alert in
            alert.urgency == urgency
        }.count
    }
}
