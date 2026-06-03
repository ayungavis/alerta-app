////
////  AudioTests.swift
////  AlertaAppTests
////
////  Created by Dimas Nugraha on 28/05/26.
////
//
//import Foundation
//@testable import AlertaApp
//
//extension DetectionEvent {
//
//    static let mockLow = DetectionEvent(
//        label: "Bicycle",
//        urgency: .low,
//        confidence: 0.61
//    )
//
//    static let mockMedium = DetectionEvent(
//        label: "Dog",
//        urgency: .medium,
//        confidence: 0.74
//    )
//
//    static let mockHigh = DetectionEvent(
//        label: "Person",
//        urgency: .high,
//        confidence: 0.88
//    )
//
//    static let mockCritical = DetectionEvent(
//        label: "Car",
//        urgency: .critical,
//        confidence: 0.97
//    )
//    
//    static let EmptyLabel = DetectionEvent(
//        label: "",
//        urgency: .medium,
//        confidence: 0.50
//    )
//
//    static let LowConfidence = DetectionEvent(
//        label: "Unknown Object",
//        urgency: .low,
//        confidence: 0.01
//    )
//
//    static let LongLabel = DetectionEvent(
//        label: "Large articulated lorry travelling at speed",
//        urgency: .high,
//        confidence: 0.83
//    )
//    
//    static let PinnedTimestamp = DetectionEvent(
//        label: "Traffic Cone",
//        urgency: .low,
//        confidence: 0.70,
//        timestamp: Date(timeIntervalSince1970: 0)  // 1 Jan 1970 00:00 UTC
//    )
//
//    static func mock(
//        label: String      = "Object",
//        urgency: AlertUrgency = .medium,
//        confidence: Float  = 0.90,
//        timestamp: Date    = .now
//    ) -> DetectionEvent {
//        DetectionEvent(
//            label: label,
//            urgency: urgency,
//            confidence: confidence,
//            timestamp: timestamp
//        )
//    }
//
//    static var allUrgencies: [DetectionEvent] {
//        AlertUrgency.allCases.map { urgency in
//            .mock(label: urgency.displayName, urgency: urgency)
//        }
//    }
//}
