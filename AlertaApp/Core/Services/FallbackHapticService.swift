//
//  FallbackHapticService.swift
//  AlertaApp
//
//  Created by Kyky on 28/05/26.
//

import Foundation
import UIKit

class FallbackHapticService: HapticFeedbackProviding {
    private let generator = UINotificationFeedbackGenerator()
    private var isMonitoring: Bool = false

    func prepare() {
        isMonitoring = true
        generator.prepare()
    }

    func playHaptic(for urgency: Urgency) {
        guard isMonitoring else { return }

        let type: UINotificationFeedbackGenerator.FeedbackType = switch urgency {
        case .low:
            .success
        case .medium, .high:
            .warning
        case .critical:
            .error
        }

        generator.notificationOccurred(type)
    }

    func stop() {
        isMonitoring = false
    }
}
