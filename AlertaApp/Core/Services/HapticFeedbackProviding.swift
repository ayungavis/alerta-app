//
//  HapticFeedbackProviding.swift
//  AlertaApp
//
//  Created by Kyky on 28/05/26.
//

import Foundation

protocol HapticFeedbackProviding {
    func prepare()
    func playHaptic(for urgency: AlertUrgency)
    func stop()
}
