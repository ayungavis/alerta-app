import CoreHaptics
import Foundation
import Observation

@Observable
class HapticRecorderManager {
    private var engine: CHHapticEngine?
    private var continuousPlayer: CHHapticPatternPlayer?
    private var previewPlayer: CHHapticPatternPlayer?

    struct RecordedStep: Identifiable {
        let id = UUID()
        let duration: TimeInterval
        let waitTime: TimeInterval
    }

    var recordedPattern: [RecordedStep] = []
    var isRecording = false

    private var lastTouchUpTime: Date?
    private var currentTouchDownTime: Date?

    init() {
        prepareHaptics()
    }

    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Gagal menyalakan haptic engine: \(error.localizedDescription)")
        }
    }

    func startRecordingSession() {
        recordedPattern.removeAll()
        lastTouchUpTime = nil
        isRecording = true
    }

    func stopRecordingSession() {
        isRecording = false
        stopContinuousHaptic()
    }

    func touchDown() {
        guard isRecording else { return }
        currentTouchDownTime = Date()
        startContinuousHaptic()
    }

    func touchUp() {
        guard isRecording, let downTime = currentTouchDownTime else { return }
        stopContinuousHaptic()

        let upTime = Date()
        let duration = upTime.timeIntervalSince(downTime)

        let waitTime: TimeInterval = if let lastUp = lastTouchUpTime {
            downTime.timeIntervalSince(lastUp)
        } else {
            0.0
        }

        let newStep = RecordedStep(duration: duration, waitTime: waitTime)
        recordedPattern.append(newStep)
        lastTouchUpTime = upTime
    }

    private func startContinuousHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [intensity, sharpness],
            relativeTime: 0,
            duration: 100
        )

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            continuousPlayer = try engine?.makePlayer(with: pattern)
            try continuousPlayer?.start(atTime: 0)
        } catch {}
    }

    private func stopContinuousHaptic() {
        do { try continuousPlayer?.stop(atTime: 0) } catch {}
    }

    func playCustomPattern(steps: [RecordedStep]) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics, !steps.isEmpty else { return }
        try? previewPlayer?.stop(atTime: 0)

        var events = [CHHapticEvent]()
        var currentTime: TimeInterval = 0

        for step in steps {
            currentTime += step.waitTime
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
            let eventType: CHHapticEvent.EventType = step.duration < 0.15 ? .hapticTransient : .hapticContinuous
            let event = CHHapticEvent(
                eventType: eventType,
                parameters: [intensity, sharpness],
                relativeTime: currentTime,
                duration: step.duration
            )
            events.append(event)
            currentTime += step.duration
        }

        do {
            let hapticPattern = try CHHapticPattern(events: events, parameters: [])
            previewPlayer = try engine?.makePlayer(with: hapticPattern)
            try previewPlayer?.start(atTime: .zero)
        } catch {}
    }

    func playRecordedPattern() {
        playCustomPattern(steps: recordedPattern)
    }

    func stopPreview() {
        try? previewPlayer?.stop(atTime: 0)
    }

    func playPreview(for patternName: String) {
        switch patternName {
        case "Steady Alert": playLowUrgency()
        case "Rapid Pulse": playMediumUrgency()
        case "Heartbeat": playHighUrgency()
        case "Emergency": playCriticalUrgency()
        default: playRecordedPattern()
        }
    }

    private func playLowUrgency() {
        var events = [CHHapticEvent]()
        var t: TimeInterval = 0
        while t < 2.0 {
            events.append(createTransient(at: t))
            t += 0.15
            events.append(createTransient(at: t))
            t += 0.15
            events.append(createContinuous(at: t, duration: 0.3))
            t += 0.45
        }
        playMultipleEvents(events)
    }

    private func playMediumUrgency() {
        var events = [CHHapticEvent]()
        var t: TimeInterval = 0
        while t < 3.0 {
            events.append(createTransient(at: t))
            t += 0.15
            events.append(createTransient(at: t))
            t += 0.15
            events.append(createContinuous(at: t, duration: 0.3))
            t += 0.45
            events.append(createContinuous(at: t, duration: 0.3))
            t += 0.45
        }
        playMultipleEvents(events)
    }

    private func playHighUrgency() {
        var events = [CHHapticEvent]()
        var t: TimeInterval = 0
        while t < 4.0 {
            events.append(createContinuous(at: t, duration: 0.3))
            t += 0.45
            events.append(createContinuous(at: t, duration: 0.3))
            t += 0.45
            events.append(createTransient(at: t))
            t += 0.15
        }
        playMultipleEvents(events)
    }

    private func playCriticalUrgency() {
        var events = [CHHapticEvent]()
        var t: TimeInterval = 0
        while t < 6.0 {
            events.append(createContinuous(at: t, duration: 0.3))
            t += 0.45
            events.append(createTransient(at: t))
            t += 0.15
            events.append(createTransient(at: t))
            t += 0.15
            events.append(createContinuous(at: t, duration: 0.3))
            t += 0.45
            events.append(createContinuous(at: t, duration: 0.3))
            t += 0.45
            events.append(createTransient(at: t))
            t += 0.15
            t += 0.2
        }
        playMultipleEvents(events)
    }

    private func createTransient(at time: TimeInterval) -> CHHapticEvent {
        CHHapticEvent(eventType: .hapticTransient, parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
        ], relativeTime: time)
    }

    private func createContinuous(at time: TimeInterval, duration: TimeInterval) -> CHHapticEvent {
        CHHapticEvent(eventType: .hapticContinuous, parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        ], relativeTime: time, duration: duration)
    }

    private func playMultipleEvents(_ events: [CHHapticEvent]) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        try? previewPlayer?.stop(atTime: 0)
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            previewPlayer = try engine?.makePlayer(with: pattern)
            try previewPlayer?.start(atTime: .zero)
        } catch {}
    }
}
