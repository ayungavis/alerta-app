//
//  AlertaAppTests.swift
//  AlertaAppTests
//
//  Created by Dimas Nugraha on 28/05/26.
//

import XCTest
import AVFoundation
@testable import AlertaApp

final class AudioOutputServiceTests: XCTestCase {
    
    func testPlayCriticalEvent() throws {
        let service = AudioOutputService()
        let event = DetectionEvent.mockCritical
        XCTAssertNoThrow(try service.play(event))
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
    }
    
    func testPlayHighEvent() throws {
        let service = AudioOutputService()
        let event = DetectionEvent.mockHigh
        XCTAssertNoThrow(try service.play(event))
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
    }

    func testPlayAllUrgencies() throws {
        let service = AudioOutputService()
        for event in DetectionEvent.allUrgencies {
            XCTAssertNoThrow(try service.play(event))
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        }
    }
}
