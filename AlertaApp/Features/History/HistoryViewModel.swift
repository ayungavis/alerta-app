//
//  HistoryViewModel.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 08/06/26.
//

import Foundation

@Observable
final class HistoryViewModel {
    var sessions: [AwarenessSessionRecord] = [] {
        didSet {
            updateSessions()
        }
    }

    var isLoading: Bool = false
    var error: Error? = nil

    private(set) var groupedSessions: [(String, [AwarenessSessionRecord])] = []
    private(set) var liveSessions: [AwarenessSessionRecord] = []
    private(set) var isLive: Bool = false

    init() {
        self.loadSessions()
    }

    func loadSessions() {
        // replace with real data source later
        sessions = AwarenessSessionRecord.mockList
    }
    
    private func updateSessions() {
        isLive = sessions.contains(where: \.isLive)
        liveSessions = sessions.filter(\.isLive)

        let cal = Calendar.current
        let dict = Dictionary(grouping: sessions.filter { !$0.isLive }) {
            cal.startOfDay(for: $0.startedAt)
        }
        groupedSessions = dict
            .sorted { $0.key > $1.key }
            .map { ($0.key.sectionHeader, $0.value.sorted { $0.startedAt > $1.startedAt }) }
    }

}
