struct AwarenessSessionState: Equatable {
    let status: AwarenessStatus
    let detectedEventKinds: [AwarenessEventKind]

    static let initial: AwarenessSessionState = .init(
        status: .notStarted,
        detectedEventKinds: []
    )
}
