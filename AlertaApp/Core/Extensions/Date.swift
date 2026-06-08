//
//  Date.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 08/06/26.
//

import Foundation

extension Date {

    var shortDate: String {
        formatted(.dateTime.day().month(.abbreviated).year())
    }

    func timeRange(to end: Date, template: String = "h:mm a") -> String {
        let formatter = DateIntervalFormatter()
        formatter.dateTemplate = template
        return formatter.string(from: self, to: end)
            .replacingOccurrences(of: "–", with: " – ")
    }

    func duration(to end: Date) -> String {
        let total = Int(end.timeIntervalSince(self))

        let years = total / 31_536_000
        let months = (total % 31_536_000) / 2_592_000
        let days = (total % 2_592_000) / 86_400
        let hours = (total % 86_400) / 3_600
        let minutes = (total % 3_600) / 60

        if years > 0 { return "\(years)y" }
        if months > 0 { return "\(months)mo" }
        if days > 0 { return "\(days)d" }
        if hours > 0 && minutes > 0 { return "\(hours)h \(minutes)m" }
        if hours > 0 && minutes == 0 { return "\(hours)h" }
        if minutes > 0 { return "\(minutes) min" }
        return "Just Now"
    }
}
