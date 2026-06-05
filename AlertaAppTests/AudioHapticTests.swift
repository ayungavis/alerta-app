import XCTest
@testable import AlertaApp // Ganti dengan nama modul utama kamu

@MainActor
final class AudioHapticTest: XCTestCase {
    
    func testPlayCriticalEvent() throws {
        let hapticService = CoreHapticService()
        let audioService = AudioOutputService()
        let event = DetectionEvent.mockCritical
        XCTAssertNoThrow(try audioService.play(event))
        XCTAssertNoThrow(hapticService.playHaptic(for: event.urgency))
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
    }
    
    func testPlayHighEvent() throws {
        let hapticService = CoreHapticService()
        let audioService = AudioOutputService()
        let event = DetectionEvent.mockHigh
        XCTAssertNoThrow(try audioService.play(event))
        XCTAssertNoThrow(hapticService.playHaptic(for: event.urgency))
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
    }

    func testPlayAllUrgencies() throws {
        let hapticService = CoreHapticService()
        let audioService = AudioOutputService()
        for event in DetectionEvent.allUrgencies {
            XCTAssertNoThrow(try audioService.play(event))
            XCTAssertNoThrow(hapticService.playHaptic(for: event.urgency))
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        }
    }
}
