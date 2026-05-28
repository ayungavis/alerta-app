import XCTest
@testable import AlertaApp // Ganti dengan nama modul utama kamu

// 1. Buat Mock (Mata-mata) untuk Haptic Service
final class MockHapticService: HapticFeedbackProviding {
    var prepareCallCount = 0
    var stopCallCount = 0
    var playedUrgencies: [AlertUrgency] = []
    
    func prepare() {
        prepareCallCount += 1
    }
    
    func playHaptic(for urgency: AlertUrgency) {
        playedUrgencies.append(urgency)
    }
    
    func stop() {
        stopCallCount += 1
    }
}

// 2. Tulis Skenario Pengujian
@MainActor
final class AwarenessViewModelTests: XCTestCase {
    
    func test_startSession_callsPrepareOnHapticService() {
        let mockHaptic = MockHapticService()
        // Asumsikan .inactive adalah salah satu case dari AwarenessSessionState kamu
        let sut = AwarenessViewModel(initialState: .inactive, hapticService: mockHaptic)
        
        sut.startSession()
        
        // Memastikan engine dipanaskan (prepare) saat start
        XCTAssertEqual(mockHaptic.prepareCallCount, 1)
    }
    
    func test_stopSession_callsStopOnHapticService() {
        let mockHaptic = MockHapticService()
        let sut = AwarenessViewModel(initialState: .active, hapticService: mockHaptic)
        
        sut.stopSession()
        
        // Memastikan engine dimatikan saat stop
        XCTAssertEqual(mockHaptic.stopCallCount, 1)
    }
    
    func test_onDetectionEventReceived_playsCorrectUrgency() {
        let mockHaptic = MockHapticService()
        let sut = AwarenessViewModel(initialState: .active, hapticService: mockHaptic)
        
        // Simulasikan AI mendeteksi klakson (Critical)
        let event = DetectionEvent(urgency: .critical, soundName: "car_horn")
        sut.onDetectionEventReceived(event)
        
        // Memastikan haptic yang dipanggil benar-benar .critical
        XCTAssertEqual(mockHaptic.playedUrgencies.count, 1)
        XCTAssertEqual(mockHaptic.playedUrgencies.first, .critical)
    }
}