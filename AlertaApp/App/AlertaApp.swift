import CoreHaptics
import SwiftUI

@main
struct AlertaApp: App {
    @State private var awarenessViewModel: AwarenessViewModel

    init() {
        let hapticService: HapticFeedbackProviding

        if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
            let defaultPatterns: [AlertUrgency: HapticPatternConfig] = [
                .low: HapticPatternConfig(events: [
                    CHHapticEvent(eventType: .hapticTransient, parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
                    ], relativeTime: 0)
                ]),

                .medium: HapticPatternConfig(events: [
                    CHHapticEvent(eventType: .hapticContinuous, parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                    ], relativeTime: 0, duration: 0.5)
                ]),

                .high: HapticPatternConfig(events: [
                    CHHapticEvent(eventType: .hapticContinuous, parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
                    ], relativeTime: 0, duration: 1.0)
                ]),

                .critical: HapticPatternConfig(events: [
                    CHHapticEvent(eventType: .hapticContinuous, parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
                    ], relativeTime: 0, duration: 2.0)
                ])
            ]

            hapticService = CoreHapticsService(patternMap: defaultPatterns)

        } else {
            hapticService = FallbackHapticService()
        }

        _awarenessViewModel = State(initialValue: AwarenessViewModel(
            initialState: AwarenessSessionState.initial,
            hapticService: hapticService
        ))
    }

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: awarenessViewModel)
        }
    }
}
