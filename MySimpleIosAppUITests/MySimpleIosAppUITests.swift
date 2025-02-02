import XCTest

class MySimpleIosAppUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func testButtonClickChangesText() {
        let button = app.buttons["Click Me"]
        let label = app.staticTexts["Hello, DevOps!"]

        XCTAssertTrue(label.exists, "Initial text should be visible.")

        button.tap()  // Simulate button click

        // Wait for the label to change
        let updatedLabel = app.staticTexts["Button Clicked!"]
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: updatedLabel, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)  // ✅ Wait up to 3 seconds

        XCTAssertTrue(updatedLabel.exists, "Text should change after button tap.")
    }

}
