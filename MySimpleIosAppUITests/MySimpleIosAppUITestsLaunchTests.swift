//
//  MySimpleIosAppUITestsLaunchTests.swift
//  MySimpleIosAppUITests
//
//  Created by Vijay Raghavan on 02/02/25.
//

import XCTest

final class MySimpleIosAppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() {
        let app = XCUIApplication()
        app.launch()

        // Wait for the main UI to appear
        let button = app.buttons["Click Me"]
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)  // ✅ Wait up to 5 seconds

        XCTAssertTrue(button.exists, "App should launch and display UI.")
    }

}
