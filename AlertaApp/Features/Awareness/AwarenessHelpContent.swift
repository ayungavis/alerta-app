//
//  AwarenessHelpContent.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 10/06/26.
//

import Foundation

enum AwarenessHelpContent: String, CaseIterable, Identifiable {
    case disclaimer
    case bestPracticesEarphone
    case bestPracticesPhonePlacement

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .disclaimer:
            "Disclaimer"
        case .bestPracticesEarphone:
            "Best practices earphone"
        case .bestPracticesPhonePlacement:
            "Best practices phone placement"
        }
    }
}
