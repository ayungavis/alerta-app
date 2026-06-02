//
//  AwarenessEventKind.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

enum AwarenessEventKind: String, CaseIterable, Identifiable {
    case approachingVehicle
    case bicycleOrScooter
    case horn
    case siren
    case nearbyMovement
    case loudSound

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .approachingVehicle:
            "Approaching vehicle"
        case .bicycleOrScooter:
            "Bicycle or scooter"
        case .horn:
            "Horn"
        case .siren:
            "Siren"
        case .nearbyMovement:
            "Nearby movement"
        case .loudSound:
            "Loud sound"
        }
    }
}
