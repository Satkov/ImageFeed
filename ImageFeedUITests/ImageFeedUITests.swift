import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()

        let webView = app.webViews["UnsplashWebView"]

        XCTAssertTrue(webView.waitForExistence(timeout: 5))


        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        passwordTextField.tap()
        passwordTextField.clearAndEnterText("password")
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.clearAndEnterText("mail")


        webView.buttons["Login"].tap()

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        print("UITest LOG: \(app.debugDescription)")

        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    func testFeed() throws {
        let tablesQuery = app.tables

        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()

        sleep(2)

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)

        cellToLike.buttons["like button"].tap()
        cellToLike.buttons["like button"].tap()

        sleep(2)

        cellToLike.tap()

        sleep(2)

        let image = app.scrollViews.images.element(boundBy: 0)

        image.pinch(withScale: 3, velocity: 1)

        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        // после имени должен быть пробел, даже если нет фамилии
        XCTAssertTrue(app.staticTexts["Georgii "].exists)
        XCTAssertTrue(app.staticTexts["@satkov"].exists)

        app.buttons["logout button"].tap()

        let alert = app.alerts["Double Button Alert"]
        XCTAssertTrue(alert.exists, "Алерт не появился")

        app.alerts["Double Button Alert"].buttons["Да"].tap()
    }
}

extension XCUIElement {
    func clearAndEnterText(_ text: String) {
        self.tap()
        self.press(forDuration: 1.0)
        self.typeText(XCUIKeyboardKey.delete.rawValue)
        self.typeText(text)
    }
}
