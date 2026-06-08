//
//  HistoryViewModel.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 08/06/26.
//

import Foundation

@Observable
final class HistoryViewModel {
    var sessions: [SessionEvent] = SessionEvent.allMocks
    var isLive: Bool = false
    
    var isLoading: Bool = false
    var error: Error? = nil
    
    init() {
        
    }

    func loadSessions() {
        // replace with real data source later
        sessions = SessionEvent.allMocks
    }

}
