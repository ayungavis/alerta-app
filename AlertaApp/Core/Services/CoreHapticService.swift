import CoreHaptics

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
    private let cooldown: TimeInterval

    var selections: [Urgency: String] = [
        .low: "Steady Alert",
        .medium: "Rapid Pulse",
        .high: "Heartbeat",
        .critical: "S.O.S."
    ]

    var customPatterns: [CustomPattern] = []

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

        switch patternName {
        case "Steady Alert":
            appendSteadyAlertEvents(to: &events)
        case "Rapid Pulse":
            appendRapidPulseEvents(to: &events)
        case "Heartbeat":
            appendHeartbeatEvents(to: &events)
        case "S.O.S.":
            appendSosEvents(to: &events)
        case "Staccato":
            appendStaccatoEvents(to: &events)
        default:
            // Fall back to custom pattern steps if name matches
            if let custom = customPatterns.first(where: {
                $0.name == patternName
            }) {
                return getEvents(fromSteps: custom.steps)
            }
        }
        return events
    }

    private func appendSteadyAlertEvents(to events: inout [CHHapticEvent]) {
        var currentTime: TimeInterval = 0

        while currentTime < 2.0 {
            appendTransient(to: &events, at: currentTime)
            currentTime += 0.15
            appendTransient(to: &events, at: currentTime)
            currentTime += 0.15
            appendContinuous(to: &events, at: currentTime, duration: 0.3)
            currentTime += 0.45
        }
    }

    private func appendRapidPulseEvents(to events: inout [CHHapticEvent]) {
        var currentTime: TimeInterval = 0

        while currentTime < 3.0 {
            appendTransient(to: &events, at: currentTime)
            currentTime += 0.15
            appendTransient(to: &events, at: currentTime)
            currentTime += 0.15
            appendContinuous(to: &events, at: currentTime, duration: 0.3)
            currentTime += 0.45
            appendContinuous(to: &events, at: currentTime, duration: 0.3)
            currentTime += 0.45
        }
    }

    private func appendHeartbeatEvents(to events: inout [CHHapticEvent]) {
        var currentTime: TimeInterval = 0

        while currentTime < 4.0 {
            appendContinuous(to: &events, at: currentTime, duration: 0.3)
            currentTime += 0.45
            appendContinuous(to: &events, at: currentTime, duration: 0.3)
            currentTime += 0.45
            appendTransient(to: &events, at: currentTime)
            currentTime += 0.15
        }
    }

    private func appendSosEvents(to events: inout [CHHapticEvent]) {
        var currentTime: TimeInterval = 0

        while currentTime < 6.0 {
            appendContinuous(to: &events, at: currentTime, duration: 0.3)
            currentTime += 0.45
            appendTransient(to: &events, at: currentTime)
            currentTime += 0.15
            appendTransient(to: &events, at: currentTime)
            currentTime += 0.15
            appendContinuous(to: &events, at: currentTime, duration: 0.3)
            currentTime += 0.45
            appendContinuous(to: &events, at: currentTime, duration: 0.3)
            currentTime += 0.45
            appendTransient(to: &events, at: currentTime)
            currentTime += 0.5
        }
    }

    private func appendStaccatoEvents(to events: inout [CHHapticEvent]) {
        var currentTime: TimeInterval = 0

        while currentTime < 2.0 {
            appendTransient(to: &events, at: currentTime)
            currentTime += 0.1
            appendTransient(to: &events, at: currentTime)
            currentTime += 0.1
            appendTransient(to: &events, at: currentTime)
            currentTime += 0.3
        }
    }

    private func appendTransient(
        to events: inout [CHHapticEvent],
        at time: TimeInterval
    ) {
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
                relativeTime: time
            )
        )
    }

    private func appendContinuous(
        to events: inout [CHHapticEvent],
        at time: TimeInterval,
        duration: TimeInterval
    ) {
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
                relativeTime: time,
                duration: duration
            )
        )
    }

    private func getEvents(for urgency: Urgency) -> [CHHapticEvent] {
        let patternName = selections[urgency] ?? urgency.defaultPatternName

        print("[CoreHapticService] selections dump: \(selections.map { "\($0.key.storageKey)=\($0.value)" }.sorted())")
        print("[CoreHapticService] urgency=\(urgency.storageKey) → resolved='\(patternName)'")

        if let custom = customPatterns.first(where: { $0.name == patternName }) {
            print("[CoreHapticService] → playing CUSTOM pattern '\(custom.name)' (\(custom.steps.count) steps)")
            return getEvents(fromSteps: custom.steps)
        }

        print("[CoreHapticService] → playing PRESET '\(patternName)'")
        return getEvents(forPreset: patternName)
    }
}

extension CoreHapticService: HapticFeedbackProviding {
    func prepare() {}

    func playHaptic(for urgency: Urgency) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }

        if let lastPlayed = lastPlayedAt[urgency],
           Date().timeIntervalSince(lastPlayed) < cooldown
        {
            return
        }

        lastPlayedAt[urgency] = Date()

        let events = getEvents(for: urgency)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.playHaptic(events: events)
        }
    }

    func stop() {
        stopHaptic()
    }
}
