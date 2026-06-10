//
//  mockData.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 10/06/26.
//

import Foundation

extension AwarenessSessionRecord {

    // MARK: - Static Mocks

    static let mockLive: AwarenessSessionRecord = {
        let id = UUID()
        return AwarenessSessionRecord(
            id: id,
            title: "Live Session",
            startedAt: Date().addingTimeInterval(-300),
            endedAt: nil,
            alerts: AwarenessAlertRecord.mockList(sessionId: id, count: 6)
        )
    }()

    static let mockEnded: AwarenessSessionRecord = {
        let id = UUID()
        let startedAt = Date().addingTimeInterval(-3600)
        return AwarenessSessionRecord(
            id: id,
            title: "Morning Walk",
            startedAt: startedAt,
            endedAt: startedAt.addingTimeInterval(2800),
            alerts: AwarenessAlertRecord.mockList(sessionId: id, count: 12)
        )
    }()

    static let mockEmpty: AwarenessSessionRecord = {
        let id = UUID()
        return AwarenessSessionRecord(
            id: id,
            title: "Quiet Session",
            startedAt: Date().addingTimeInterval(-120),
            endedAt: Date(),
            alerts: []
        )
    }()

    static let mockCriticalHeavy: AwarenessSessionRecord = {
        let id = UUID()
        let startedAt = Date().addingTimeInterval(-1800)
        return AwarenessSessionRecord(
            id: id,
            title: "Busy Street",
            startedAt: startedAt,
            endedAt: startedAt.addingTimeInterval(1500),
            alerts: [
                .mock(sessionId: id, soundEvent: .siren, urgency: .critical, direction: .frontLeft, timestamp: startedAt.addingTimeInterval(120)),
                .mock(sessionId: id, soundEvent: .siren, urgency: .critical, direction: .backLeft, timestamp: startedAt.addingTimeInterval(300)),
                .mock(sessionId: id, soundEvent: .approachingVehicle, urgency: .high, direction: .frontRight, timestamp: startedAt.addingTimeInterval(500)),
                .mock(sessionId: id, soundEvent: .nearbyPersonMovement, urgency: .medium, direction: .right, timestamp: startedAt.addingTimeInterval(800)),
                .mock(sessionId: id, soundEvent: .bicycleOrScooter, urgency: .low, direction: .nearby, timestamp: startedAt.addingTimeInterval(1200)),
            ]
        )
    }()

    // MARK: - Factory

    static func mock(
        title: String = "Test Session",
        startedAt: Date = .now,
        endedAt: Date? = Date().addingTimeInterval(600),
        alerts: [AwarenessAlertRecord]? = nil
    ) -> AwarenessSessionRecord {
        let id = UUID()
        return AwarenessSessionRecord(
            id: id,
            title: title,
            startedAt: startedAt,
            endedAt: endedAt,
            alerts: alerts ?? AwarenessAlertRecord.mockList(sessionId: id, count: 4)
        )
    }

    // MARK: - List

    static var mockList: [AwarenessSessionRecord] {
        [mockLive, mockEnded, mockCriticalHeavy, mockEmpty]
    }
}

extension AwarenessAlertRecord {

    // MARK: - Static Mocks

    static let mockLow = AwarenessAlertRecord(
        id: UUID(),
        sessionId: UUID(),
        soundEvent: .bicycleOrScooter,
        urgency: .low,
        direction: .frontLeft,
        confidence: 0.61,
        rawIdentifier: "bicycle",
        timestamp: .now,
        soundName: "bicycle_sound",
        soundLevelDecibels: 52.0
    )

    static let mockMedium = AwarenessAlertRecord(
        id: UUID(),
        sessionId: UUID(),
        soundEvent: .nearbyPersonMovement,
        urgency: .medium,
        direction: .right,
        confidence: 0.74,
        rawIdentifier: "dog_bark",
        timestamp: .now,
        soundName: "dog_bark_sound",
        soundLevelDecibels: 68.0
    )

    static let mockHigh = AwarenessAlertRecord(
        id: UUID(),
        sessionId: UUID(),
        soundEvent: .approachingVehicle,
        urgency: .high,
        direction: .frontRight,
        confidence: 0.88,
        rawIdentifier: "approaching_vehicle",
        timestamp: .now,
        soundName: "vehicle_sound",
        soundLevelDecibels: 78.0
    )

    static let mockCritical = AwarenessAlertRecord(
        id: UUID(),
        sessionId: UUID(),
        soundEvent: .siren,
        urgency: .critical,
        direction: .backLeft,
        confidence: 0.97,
        rawIdentifier: "siren",
        timestamp: .now,
        soundName: "siren_sound",
        soundLevelDecibels: 95.0
    )

    // MARK: - Factory

    static func mock(
        sessionId: UUID = UUID(),
        soundEvent: SoundEvent = .generalLoudSound,
        urgency: Urgency = .medium,
        direction: SoundDirection = .nearby,
        confidence: Float = 0.90,
        rawIdentifier: String = "object",
        timestamp: Date = .now,
        soundName: String? = "test",
        soundLevelDecibels: Float? = 65.0
    ) -> AwarenessAlertRecord {
        AwarenessAlertRecord(
            id: UUID(),
            sessionId: sessionId,
            soundEvent: soundEvent,
            urgency: urgency,
            direction: direction,
            confidence: confidence,
            rawIdentifier: rawIdentifier,
            timestamp: timestamp,
            soundName: soundName,
            soundLevelDecibels: soundLevelDecibels
        )
    }

    // MARK: - All Urgencies

    static var allUrgencies: [AwarenessAlertRecord] {
        Urgency.allCases.map { urgency in
            let event = SoundEvent.allCases.first { $0.urgency == urgency } ?? .generalLoudSound
            return mock(soundEvent: event, urgency: urgency)
        }
    }

    // MARK: - Bulk Session Mocks

    static func mockList(sessionId: UUID, count: Int = 5) -> [AwarenessAlertRecord] {
        let urgencies: [Urgency] = [.low, .medium, .high, .critical]
        return (0..<count).map { index in
            let urgency = urgencies[index % urgencies.count]
            let event = SoundEvent.allCases.first { $0.urgency == urgency } ?? .generalLoudSound
            return mock(
                sessionId: sessionId,
                soundEvent: event,
                urgency: urgency,
                timestamp: Date().addingTimeInterval(-Double(index) * 30)
            )
        }
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
