import CoreHaptics
import Observation

@Observable
class CoreHapticService {
    private var engine: CHHapticEngine?
    private var previewPlayer: CHHapticPatternPlayer?
    private var continuousPlayer: CHHapticPatternPlayer?

    var recordedPattern: [RecordedStep] = []
    var isRecording = false
    private var lastTouchUpTime: Date?
    private var currentTouchDownTime: Date?

    private var lastPlayedAt: [Urgency: Date]
    private let cooldown: TimeInterval // seconds

    init(
        cooldown: TimeInterval = 10.0,
        lastPlayedAt: [Urgency: Date] = [:]
    ) {
        self.cooldown = cooldown
        self.lastPlayedAt = lastPlayedAt
        setupEngine()
    }

    private func setupEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        do {
            engine = try CHHapticEngine()

            engine?.stoppedHandler = { [weak self] reason in
                print("Haptic engine stopped: \(reason)")
                try? self?.engine?.start()
            }
            engine?.resetHandler = { [weak self] in
                print("Haptic engine reset")
                try? self?.engine?.start()
            }

            try engine?.start()
        } catch {
            print("Gagal inisialisasi haptic: \(error.localizedDescription)")
        }
    }

    func playHaptic(events: [CHHapticEvent]) {
        try? previewPlayer?.stop(atTime: 0)
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              !events.isEmpty
        else { return }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            previewPlayer = try engine?.makePlayer(with: pattern)
            try previewPlayer?.start(atTime: 0)
        } catch {
            print("Gagal play haptic: \(error.localizedDescription)")
        }
    }

    func stopHaptic() {
        try? previewPlayer?.stop(atTime: 0)
    }

    func startRecordingSession() {
        recordedPattern.removeAll()
        lastTouchUpTime = nil
        isRecording = true
    }

    func stopRecordingSession() {
        isRecording = false
        try? continuousPlayer?.stop(atTime: 0)
    }

    func touchDown() {
        guard isRecording else { return }
        currentTouchDownTime = Date()

        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(
                    parameterID: .hapticIntensity,
                    value: 1.0
                ),
                CHHapticEventParameter(
                    parameterID: .hapticSharpness,
                    value: 0.5
                )
            ],
            relativeTime: 0,
            duration: 100
        )

        do {
            continuousPlayer = try engine?.makePlayer(
                with: CHHapticPattern(events: [event], parameters: [])
            )
            try continuousPlayer?.start(atTime: 0)
        } catch {}
    }

    func touchUp() {
        guard isRecording, let downTime = currentTouchDownTime else { return }
        try? continuousPlayer?.stop(atTime: 0)

        let upTime = Date()
        let duration = upTime.timeIntervalSince(downTime)
        let waitTime: TimeInterval =
            if let lastUp = lastTouchUpTime {
                downTime.timeIntervalSince(lastUp)
            } else { 0.0 }

        recordedPattern.append(
            RecordedStep(duration: duration, waitTime: waitTime)
        )
        lastTouchUpTime = upTime
    }

    func getEvents(fromSteps steps: [RecordedStep]) -> [CHHapticEvent] {
        var events = [CHHapticEvent]()
        var currentTime: TimeInterval = 0

        for step in steps {
            currentTime += step.waitTime
            let isTransient = step.duration < 0.15

            let event = CHHapticEvent(
                eventType: isTransient ? .hapticTransient : .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(
                        parameterID: .hapticIntensity,
                        value: isTransient ? 0.8 : 1.0
                    ),
                    CHHapticEventParameter(
                        parameterID: .hapticSharpness,
                        value: isTransient ? 0.8 : 0.5
                    )
                ],
                relativeTime: currentTime,
                duration: isTransient ? 0 : step.duration
            )
            events.append(event)
            currentTime += step.duration
        }
        return events
    }

    func getEvents(forPreset patternName: String) -> [CHHapticEvent] {
        var events = [CHHapticEvent]()
        var t: TimeInterval = 0

        func addTransient() {
            events.append(
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(
                            parameterID: .hapticIntensity,
                            value: 0.8
                        ),
                        CHHapticEventParameter(
                            parameterID: .hapticSharpness,
                            value: 0.8
                        )
                    ],
                    relativeTime: t
                )
            )
        }
        func addContinuous(duration: TimeInterval) {
            events.append(
                CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [
                        CHHapticEventParameter(
                            parameterID: .hapticIntensity,
                            value: 1.0
                        ),
                        CHHapticEventParameter(
                            parameterID: .hapticSharpness,
                            value: 0.5
                        )
                    ],
                    relativeTime: t,
                    duration: duration
                )
            )
        }

        switch patternName {
        case "Steady Alert":
            while t < 2.0 {
                addTransient()
                t += 0.15
                addTransient()
                t += 0.15
                addContinuous(duration: 0.3)
                t += 0.45
            }
        case "Rapid Pulse":
            while t < 3.0 {
                addTransient()
                t += 0.15
                addTransient()
                t += 0.15
                addContinuous(duration: 0.3)
                t += 0.45
                addContinuous(duration: 0.3)
                t += 0.45
            }
        case "Heartbeat":
            while t < 4.0 {
                addContinuous(duration: 0.3)
                t += 0.45
                addContinuous(duration: 0.3)
                t += 0.45
                addTransient()
                t += 0.15
            }
        case "S.O.S.":
            while t < 6.0 {
                addContinuous(duration: 0.3)
                t += 0.45
                addTransient()
                t += 0.15
                addTransient()
                t += 0.15
                addContinuous(duration: 0.3)
                t += 0.45
                addContinuous(duration: 0.3)
                t += 0.45
                addTransient()
                t += 0.5
            }
        default: break
        }
        return events
    }
}

extension CoreHapticService: HapticFeedbackProviding {
    func prepare() {}

    func playHaptic(for urgency: Urgency) {
        let patternName =
            switch urgency {
            case .low: "Steady Alert"
            case .medium: "Rapid Pulse"
            case .high: "Heartbeat"
            case .critical: "S.O.S."
            }

        // Skip if same urgency played within cooldown window
        if let lastPlayed = lastPlayedAt[urgency],
           Date().timeIntervalSince(lastPlayed) < cooldown
        {
            return
        }

        lastPlayedAt[urgency] = Date()

        let events = getEvents(forPreset: patternName)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.playHaptic(events: events)
        }
    }

    func stop() {
        stopHaptic()
    }
}
