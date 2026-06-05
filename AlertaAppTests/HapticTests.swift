import XCTest
@testable import AlertaApp // Ganti dengan nama modul utama kamu

// 1. Buat Mock (Mata-mata) untuk Haptic Service
final class MockHapticService: HapticFeedbackProviding {
    var prepareCallCount = 0
    var stopCallCount = 0
    var playedUrgencies: [Urgency] = []
    
    func prepare() {
        prepareCallCount += 1
    }
    
    func playHaptic(for urgency: Urgency) {
        playedUrgencies.append(urgency)
    }
    
    func stop() {
        stopCallCount += 1
    }
}

// 2. Tulis Skenario Pengujian
@MainActor
final class AwarenessViewModelTests: XCTestCase {
    
    func testPlayCriticalEvent() throws {
        let service = HapticRecorderManager()
        let event = DetectionEvent.mockCritical
        XCTAssertNoThrow(service.playPreview(event))
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
    }
    
    func testPlayHighEvent() throws {
        let service = HapticRecorderManager()
        let event = DetectionEvent.mockHigh
        XCTAssertNoThrow(service.playPreview(event))
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
    }

    func testPlayAllUrgencies() throws {
        let service = HapticRecorderManager()
        for event in DetectionEvent.allUrgencies {
            XCTAssertNoThrow(service.playPreview(event))
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        }
    }
}
