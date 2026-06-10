//
//  SessionHistoryStore.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 08/06/26.
//

import Foundation
import SwiftData

@Observable
@MainActor
final class SessionHistoryStore {
    private struct PersistedState {
        let completedSessions: [AwarenessSessionRecord]
    }

    ///    private let fileURL: URL
    ///    private let fileManager: FileManager
    private let modelContext: ModelContext

    private(set) var liveSession: AwarenessSessionRecord?
    private(set) var completedSessions: [AwarenessSessionRecord]
    private(set) var latestPersistenceError: Error?

    init(modelContext: ModelContext
//         , fileURL: URL, fileManager: FileManager
    ) {
        self.modelContext = modelContext
//        self.fileURL = fileURL
//        self.fileManager = fileManager
        completedSessions = []
//        loadCompletedSessions()
    }

    static func defaultFileURL() -> URL {
        guard
            let applicationSupportURL = FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            ).first
        else {
            preconditionFailure(
                "Application Support directory is unavailable for session history storage."
            )
        }

        return
            applicationSupportURL
                .appendingPathComponent("SessionHistory", isDirectory: true)
                .appendingPathComponent("sessions.json", isDirectory: false)
    }

    func startSession(at startedAt: Date) {
        guard liveSession == nil else {
            assertionFailure(
                "Cannot start a new awareness session while another session is live."
            )
            return
        }

        let session = AwarenessSessionRecord(
            id: UUID(),
            title: sessionTitle(for: startedAt),
            startedAt: startedAt,
            endedAt: nil,
            alerts: []
        )

        modelContext.insert(session)
        liveSession = session
    }

    func recordAlert(from event: DetectionEvent) {
        guard let session = liveSession else {
            assertionFailure(
                "Cannot record an awareness alert without a live session."
            )
            return
        }

        session.alerts.append(alertRecord(from: event, sessionId: session.id))
        liveSession = session
    }

    func finishLiveSession(at endedAt: Date) {
        guard let session = liveSession else {
            return
        }

        session.endedAt = endedAt

        do {
            try modelContext.save()
        } catch {
            print(AppError.dataError(.saveFailed(error)))
        }

        completedSessions.insert(session, at: 0)
        liveSession = nil
//        persistCompletedSessions()
    }

//    private func loadCompletedSessions() {
//        guard fileManager.fileExists(atPath: fileURL.path) else {
//            return
//        }
//
//        do {
//            let data = try Data(contentsOf: fileURL)
//            let decodedState = try decoder().decode(
//                PersistedState.self,
//                from: data
//            )
//            completedSessions = decodedState.completedSessions.sorted {
//                lhs,
//                rhs in
//                lhs.startedAt > rhs.startedAt
//            }
//            latestPersistenceError = nil
//        } catch {
//            latestPersistenceError = error
//            assertionFailure(
//                "Failed to load awareness session history from \(fileURL.path): \(error)"
//            )
//        }
//    }

//    private func persistCompletedSessions() {
//        do {
//            try fileManager.createDirectory(
//                at: fileURL.deletingLastPathComponent(),
//                withIntermediateDirectories: true,
//                attributes: nil
//            )
//
//            let state = PersistedState(completedSessions: completedSessions)
//            let data = try encoder().encode(state)
//            try data.write(to: fileURL, options: [.atomic])
//            latestPersistenceError = nil
//        } catch {
//            latestPersistenceError = error
//            assertionFailure(
//                "Failed to persist awareness session history to \(fileURL.path): \(error)"
//            )
//        }
//    }

    private func alertRecord(from event: DetectionEvent, sessionId: UUID)
        -> AwarenessAlertRecord
    {
        AwarenessAlertRecord(
            id: UUID(),
            sessionId: sessionId,
            soundEvent: event.soundEvent,
            urgency: event.urgency,
            direction: event.direction,
            confidence: event.confidence,
            rawIdentifier: event.rawIdentifier,
            timestamp: event.timestamp,
            soundName: event.soundName,
            soundLevelDecibels: nil
        )
    }

    private func sessionTitle(for date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)

        switch hour {
        case 5 ..< 12:
            return "Morning Session"
        case 12 ..< 17:
            return "Afternoon Session"
        case 17 ..< 21:
            return "Evening Session"
        default:
            return "Night Session"
        }
    }

    private func encoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }

    private func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
