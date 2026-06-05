// import CoreHaptics
// import Foundation
// import Observation
//
// @Observable
// class CoreHapticService {
//    private var engine: CHHapticEngine?
//    private var continuousPlayer: CHHapticPatternPlayer?
//    private var previewPlayer: CHHapticPatternPlayer?
//
//    struct RecordedStep: Identifiable {
//        let id = UUID()
//        let duration: TimeInterval
//        let waitTime: TimeInterval
//    }
//
//    var recordedPattern: [RecordedStep] = []
//    var isRecording = false
//
//    private var lastTouchUpTime: Date?
//    private var currentTouchDownTime: Date?
//
//    init() {
//        prepareHaptics()
//    }
//
//    func prepareHaptics() {
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
//        do {
//            engine = try CHHapticEngine()
//            try engine?.start()
//        } catch {
//            print("Gagal menyalakan haptic engine: \(error.localizedDescription)")
//        }
//    }
//
//    func startRecordingSession() {
//        recordedPattern.removeAll()
//        lastTouchUpTime = nil
//        isRecording = true
//    }
//
//    func stopRecordingSession() {
//        isRecording = false
//        stopContinuousHaptic()
//    }
//
//    func touchDown() {
//        guard isRecording else { return }
//        currentTouchDownTime = Date()
//        startContinuousHaptic()
//    }
//
//    func touchUp() {
//        guard isRecording, let downTime = currentTouchDownTime else { return }
//        stopContinuousHaptic()
//
//        let upTime = Date()
//        let duration = upTime.timeIntervalSince(downTime)
//        let waitTime: TimeInterval = if let lastUp = lastTouchUpTime {
//            downTime.timeIntervalSince(lastUp)
//        } else {
//            0.0
//        }
//
//        recordedPattern.append(RecordedStep(duration: duration, waitTime: waitTime))
//        lastTouchUpTime = upTime
//    }
//
//    private func startContinuousHaptic() {
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
//        let event = createContinuous(at: 0, duration: 100)
//        do {
//            continuousPlayer = try engine?.makePlayer(with: try CHHapticPattern(events: [event], parameters: []))
//            try continuousPlayer?.start(atTime: 0)
//        } catch {}
//    }
//
//    private func stopContinuousHaptic() {
//        try? continuousPlayer?.stop(atTime: 0)
//    }
//
//    func playHaptic(events: [CHHapticEvent]) {
//        try? previewPlayer?.stop(atTime: 0)
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics, !events.isEmpty else { return }
//
//        do {
//            let pattern = try CHHapticPattern(events: events, parameters: [])
//            previewPlayer = try engine?.makePlayer(with: pattern)
//            try previewPlayer?.start(atTime: .zero)
//        } catch {
//            print("Gagal memutar haptic: \(error.localizedDescription)")
//        }
//    }
//
//    func stopHaptic() {
//        try? previewPlayer?.stop(atTime: 0)
//    }
//
//
//    func getEvents(fromSteps steps: [RecordedStep]) -> [CHHapticEvent] {
//        var events = [CHHapticEvent]()
//        var currentTime: TimeInterval = 0
//
//        for step in steps {
//            currentTime += step.waitTime
//            let isTransient = step.duration < 0.15
//            let event = isTransient ? createTransient(at: currentTime) : createContinuous(at: currentTime, duration:
//            step.duration)
//            events.append(event)
//            currentTime += step.duration
//        }
//        return events
//    }
//
//    /// Mengubah nama bawaan (Preset) menjadi Haptic Events
//    func getEvents(forPreset patternName: String) -> [CHHapticEvent] {
//        var events = [CHHapticEvent]()
//        var t: TimeInterval = 0
//
//        switch patternName {
//        case "Steady Alert":
//            while t < 2.0 {
//                events.append(createTransient(at: t)); t += 0.15
//                events.append(createTransient(at: t)); t += 0.15
//                events.append(createContinuous(at: t, duration: 0.3)); t += 0.45
//            }
//        case "Rapid Pulse":
//            while t < 3.0 {
//                events.append(createTransient(at: t)); t += 0.15
//                events.append(createTransient(at: t)); t += 0.15
//                events.append(createContinuous(at: t, duration: 0.3)); t += 0.45
//                events.append(createContinuous(at: t, duration: 0.3)); t += 0.45
//            }
//        case "Heartbeat":
//            while t < 4.0 {
//                events.append(createContinuous(at: t, duration: 0.3)); t += 0.45
//                events.append(createContinuous(at: t, duration: 0.3)); t += 0.45
//                events.append(createTransient(at: t)); t += 0.15
//            }
//        case "Emergency":
//            while t < 6.0 {
//                events.append(createContinuous(at: t, duration: 0.3)); t += 0.45
//                events.append(createTransient(at: t)); t += 0.15
//                events.append(createTransient(at: t)); t += 0.15
//                events.append(createContinuous(at: t, duration: 0.3)); t += 0.45
//                events.append(createContinuous(at: t, duration: 0.3)); t += 0.45
//                events.append(createTransient(at: t)); t += 0.35 // Digabung jedanya
//            }
//        default:
//            break
//        }
//        return events
//    }
//
//    // MARK: - Helper Components
//    private func createTransient(at time: TimeInterval) -> CHHapticEvent {
//        CHHapticEvent(eventType: .hapticTransient, parameters: [
//            CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
//            CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
//        ], relativeTime: time)
//    }
//
//    private func createContinuous(at time: TimeInterval, duration: TimeInterval) -> CHHapticEvent {
//        CHHapticEvent(eventType: .hapticContinuous, parameters: [
//            CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
//            CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
//        ], relativeTime: time, duration: duration)
//    }
// }
