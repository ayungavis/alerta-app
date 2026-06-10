//
//  AwarenessSessionRecord.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 08/06/26.
//

import Foundation
import SwiftData

@Model
final class AwarenessSessionRecord {
    var id: UUID
    var title: String
    var startedAt: Date
    var endedAt: Date?

    var alerts: [AwarenessAlertRecord] = []

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

    @Relationship(deleteRule: .cascade)

    init(id: UUID = UUID(), title: String, startedAt: Date, endedAt: Date? = nil, alerts: [AwarenessAlertRecord] = []) {
        self.id = id
        self.title = title
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.alerts = alerts
    }

    func alertCount(for urgency: Urgency) -> Int {
        alerts.filter { alert in
            alert.urgency == urgency
        }.count
    }
}
