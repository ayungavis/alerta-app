import Observation
import Foundation

@Observable
@MainActor
final class AwarenessViewModel {
    private(set) var state: AwarenessSessionState
    
    private let hapticService: HapticFeedbackProviding

    init(initialState: AwarenessSessionState, hapticService: HapticFeedbackProviding) {
        self.state = initialState
        self.hapticService = hapticService
    }

    var availableEventKinds: [AwarenessEventKind] {
        AwarenessEventKind.allCases
    }
    
    func onDetectionEventReceived(_ event: DetectionEvent) {
        hapticService.playHaptic(for: event.urgency)
    }
    
    func startSession() {
        hapticService.prepare()
    }
    
    func stopSession() {
        hapticService.stop()
    }
}
