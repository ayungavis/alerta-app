//
//  Urgency.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 03/06/26.
//

import Foundation

/// Severity classification shared across haptic, audio, and visual feedback layers.
/// Extend this file with domain-specific computed properties rather than scattering urgency logic across service files.
enum Urgency: Int, Comparable, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2
    case critical = 3

    static func < (lhs: Urgency, rhs: Urgency) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    /// Human-readable label used in logging and debugging.
    var displayName: String {
        switch self {
        case .low: "Low"
        case .medium: "Medium"
        case .high: "High"
        case .critical: "Critical"
        }
    }
}

// MARK: - Audio properties for Urgency

extension Urgency {
    /// Whether audio output should interrupt other system sounds.
    /// Only `critical` and `high` events warrant interruption.
    var shouldInterruptAudio: Bool {
        self >= .high
    }

    /// Minimum interval (seconds) before an identical urgency level may trigger another audio alert, preventing alert
    /// fatigue.
    var minimumRepeatInterval: TimeInterval {
        switch self {
        case .critical: 2.0
        case .high: 3.0
        case .medium: 5.0
        case .low: 8.0
        }
    }
}
