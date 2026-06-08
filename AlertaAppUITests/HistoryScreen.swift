//
//  HistoryScreen.swift
//  AlertaAppTests
//
//  Created by Dimas Nugraha on 07/06/26.
//

import XCTest
@testable import AlertaApp

final class HistoryScreen: XCTestCase {
    
    func testViewCreates() {
        let app = XCUIApplication()
           app.launchArguments = ["--show-history"]
           app.launch()

           RunLoop.main.run()
    }
}
