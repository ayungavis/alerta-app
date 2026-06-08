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

extension SessionEvent {

    // MARK: - Static Mocks

    static let mockShort = SessionEvent(
        id: UUID(),
        name: "Short Session",
        start: Date(timeIntervalSinceNow: -300),
        end: Date(timeIntervalSinceNow: -60),
        events: [.mockLow, .mockMedium]
    )

    static let mockMediumSession = SessionEvent(
        id: UUID(),
        name: "Medium Session",
        start: Date(timeIntervalSinceNow: -1800),
        end: Date(timeIntervalSinceNow: -600),
        events: [.mockLow, .mockMedium, .mockHigh, .mockMedium, .mockLow]
    )

    static let mockLongSession = SessionEvent(
        id: UUID(),
        name: "Long Session",
        start: Date(timeIntervalSinceNow: -7200),
        end: Date(timeIntervalSinceNow: -3600),
        events: DetectionEvent.allUrgencies
            + DetectionEvent.allDirections
            + DetectionEvent.allSoundEvents
    )

    static let mockCriticalSession = SessionEvent(
        id: UUID(),
        name: "Critical Event Session",
        start: Date(timeIntervalSinceNow: -900),
        end: Date(timeIntervalSinceNow: -300),
        events: [.mockLow, .mockMedium, .mockHigh, .mockCritical]
    )

    static let mockEmpty = SessionEvent(
        id: UUID(),
        name: "Empty Session",
        start: Date(timeIntervalSinceNow: -120),
        end: Date(timeIntervalSinceNow: -60),
        events: []
    )

    static let mockEdgeCases = SessionEvent(
        id: UUID(),
        name: "Edge Cases",
        start: Date(timeIntervalSince1970: 0),
        end: Date(timeIntervalSince1970: 60),
        events: [
            .mockEmptyLabel,
            .mockLowConfidence,
            .mockLongLabel,
            .mockPinnedTimestamp,
        ]
    )

    // MARK: - Factory

    static func mock(
        name: String = "Test Session",
        duration: TimeInterval = 600,
        end: Date = .now,
        events: [DetectionEvent] = [.mockLow, .mockMedium, .mockHigh]
    ) -> SessionEvent {
        SessionEvent(
            id: UUID(),
            name: name,
            start: end.addingTimeInterval(-duration),
            end: end,
            events: events
        )
    }

    // MARK: - All Sessions

    static var allMocks: [SessionEvent] {
        [
            .mockShort,
            .mockMediumSession,
            .mockLongSession,
            .mockCriticalSession,
            .mockEmpty,
            .mockEdgeCases,
        ]
    }
}

extension DetectionEvent {

    // MARK: - Helpers

    private static func makeSpectrum(
        subBass: Float = 0.01,
        bass: Float = 0.01,
        lowMid: Float = 0.01,
        mid: Float = 0.01,
        highMid: Float = 0.01,
        high: Float = 0.01,
        dominant: Float = 440,
        centroid: Float = 500
    ) -> FrequencySpectrum {
        let energies = [subBass, bass, lowMid, mid, highMid, high]
        let bands = zip(FrequencyBand.defaultBands, energies).map {
            FrequencyBand(name: $0.name, range: $0.range, energy: $1)
        }
        return FrequencySpectrum(
            bands: bands,
            dominantFrequency: dominant,
            spectralCentroid: centroid
        )
    }

    // MARK: - Static Mocks

    static let mockLow = DetectionEvent(
        id: UUID(),
        soundEvent: .bicycleOrScooter,
        direction: .frontLeft,
        confidence: 0.61,
        urgency: .low,
        topCandidates: [
            DetectionCandidate(identifier: "bicycle", confidence: 0.61),
            DetectionCandidate(identifier: "scooter", confidence: 0.22),
        ],
        rawIdentifier: "bicycle",
        timestamp: .now,
        frequencyInfo: makeSpectrum(
            bass: 0.02,
            lowMid: 0.015,
            dominant: 180,
            centroid: 300
        ),
        soundName: "test"
    )

    static let mockMedium = DetectionEvent(
        id: UUID(),
        soundEvent: .nearbyPersonMovement,
        direction: .right,
        confidence: 0.74,
        urgency: .medium,
        topCandidates: [
            DetectionCandidate(identifier: "dog_bark", confidence: 0.74),
            DetectionCandidate(identifier: "animal", confidence: 0.18),
        ],
        rawIdentifier: "dog_bark",
        timestamp: .now,
        frequencyInfo: makeSpectrum(
            mid: 0.03,
            highMid: 0.025,
            dominant: 800,
            centroid: 1200
        ),
        soundName: "test"
    )

    static let mockHigh = DetectionEvent(
        id: UUID(),
        soundEvent: .approachingVehicle,
        direction: .frontRight,
        confidence: 0.88,
        urgency: .high,
        topCandidates: [
            DetectionCandidate(
                identifier: "approaching_vehicle",
                confidence: 0.88
            ),
            DetectionCandidate(identifier: "car_engine", confidence: 0.09),
        ],
        rawIdentifier: "approaching_vehicle",
        timestamp: .now,
        frequencyInfo: makeSpectrum(
            subBass: 0.04,
            bass: 0.035,
            lowMid: 0.02,
            dominant: 120,
            centroid: 400
        ),
        soundName: "test"
    )

    static let mockCritical = DetectionEvent(
        id: UUID(),
        soundEvent: .siren,
        direction: .backLeft,
        confidence: 0.97,
        urgency: .critical,
        topCandidates: [
            DetectionCandidate(identifier: "siren", confidence: 0.97),
            DetectionCandidate(identifier: "horn", confidence: 0.02),
        ],
        rawIdentifier: "siren",
        timestamp: .now,
        frequencyInfo: makeSpectrum(
            mid: 0.04,
            highMid: 0.045,
            high: 0.03,
            dominant: 1200,
            centroid: 2000
        ),
        soundName: "test"
    )

    static let mockEmptyLabel = DetectionEvent(
        id: UUID(),
        soundEvent: .generalLoudSound,
        direction: .unknown,
        confidence: 0.50,
        urgency: .medium,
        topCandidates: [],
        rawIdentifier: "",
        timestamp: .now,
        frequencyInfo: .zero,
        soundName: "test"
    )

    static let mockLowConfidence = DetectionEvent(
        id: UUID(),
        soundEvent: .generalLoudSound,
        direction: .nearby,
        confidence: 0.01,
        urgency: .low,
        topCandidates: [
            DetectionCandidate(identifier: "unknown", confidence: 0.01)
        ],
        rawIdentifier: "unknown",
        timestamp: .now,
        frequencyInfo: makeSpectrum(dominant: 300, centroid: 350),
        soundName: "test"
    )

    static let mockLongLabel = DetectionEvent(
        id: UUID(),
        soundEvent: .approachingVehicle,
        direction: .frontLeft,
        confidence: 0.83,
        urgency: .high,
        topCandidates: [
            DetectionCandidate(
                identifier: "approaching_vehicle",
                confidence: 0.83
            ),
            DetectionCandidate(identifier: "truck", confidence: 0.10),
        ],
        rawIdentifier: "large_articulated_lorry",
        timestamp: .now,
        frequencyInfo: makeSpectrum(
            subBass: 0.05,
            bass: 0.045,
            lowMid: 0.03,
            dominant: 80,
            centroid: 250
        ),
        soundName: "test"
    )

    static let mockPinnedTimestamp = DetectionEvent(
        id: UUID(),
        soundEvent: .generalLoudSound,
        direction: .nearby,
        confidence: 0.70,
        urgency: .low,
        topCandidates: [
            DetectionCandidate(identifier: "traffic_cone", confidence: 0.70)
        ],
        rawIdentifier: "traffic_cone",
        timestamp: Date(timeIntervalSince1970: 0),
        frequencyInfo: makeSpectrum(
            lowMid: 0.02,
            mid: 0.018,
            dominant: 400,
            centroid: 600
        ),
        soundName: "test"
    )

    // MARK: - Factory

    static func mock(
        soundEvent: SoundEvent = .generalLoudSound,
        direction: SoundDirection = .nearby,
        confidence: Float = 0.90,
        urgency: Urgency = .medium,
        rawIdentifier: String = "object",
        timestamp: Date = .now,
        frequencyInfo: FrequencySpectrum? = .zero
    ) -> DetectionEvent {
        DetectionEvent(
            id: UUID(),
            soundEvent: soundEvent,
            direction: direction,
            confidence: confidence,
            urgency: urgency,
            topCandidates: [
                DetectionCandidate(
                    identifier: rawIdentifier,
                    confidence: confidence
                )
            ],
            rawIdentifier: rawIdentifier,
            timestamp: timestamp,
            frequencyInfo: frequencyInfo,
            soundName: "test"
        )
    }

    // MARK: - All Urgencies

    static var allUrgencies: [DetectionEvent] {
        Urgency.allCases.map { urgency in
            let event =
                SoundEvent.allCases.first { $0.urgency == urgency }
                ?? .generalLoudSound
            return mock(soundEvent: event, urgency: urgency)
        }
    }

    // MARK: - All Directions

    static var allDirections: [DetectionEvent] {
        [
            .frontLeft, .frontRight, .backLeft, .backRight, .left, .right,
            .nearby, .unknown,
        ].map { direction in
            mock(
                soundEvent: .approachingVehicle,
                direction: direction,
                rawIdentifier: direction.rawValue
            )
        }
    }

    // MARK: - All Sound Events

    static var allSoundEvents: [DetectionEvent] {
        SoundEvent.allCases.map { event in
            mock(
                soundEvent: event,
                urgency: event.urgency,
                rawIdentifier: event.rawValue
            )
        }
    }
}

