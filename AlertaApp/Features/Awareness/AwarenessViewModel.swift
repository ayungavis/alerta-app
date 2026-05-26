import Observation

@Observable
@MainActor
final class AwarenessViewModel {
    private(set) var state: AwarenessSessionState

    init(initialState: AwarenessSessionState) {
        state = initialState
    }

    var availableEventKinds: [AwarenessEventKind] {
        AwarenessEventKind.allCases
    }
}
