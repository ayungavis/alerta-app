//
//  AwarenessSessionState.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

struct AwarenessSessionState: Equatable {
    let status: AwarenessStatus
    let detectedEventKinds: [AwarenessEventKind]

    static let initial: AwarenessSessionState = .init(
        status: .notStarted,
        detectedEventKinds: []
    )
}
