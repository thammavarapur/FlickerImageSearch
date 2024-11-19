//
//  FlickrImageSearchUITestsLaunchTests.swift
//  FlickrImageSearchUITests
//
//  Created by Rajesh Thammavarapu on 11/19/24.
//

import XCTest

final class FlickrImageSearchUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
   }
    func testSearchBarExists() {
        let app = XCUIApplication()
        app.launch()
        
        let searchBar = app.textFields["Search Flickr"]
        XCTAssertTrue(searchBar.exists, "The search bar should be visible on launch.")
    }
    func testSearchShowsProgressIndicator() {
        let app = XCUIApplication()
        app.launch()
        
        let searchBar = app.textFields["Search Flickr"]
        searchBar.tap()
        searchBar.typeText("nature")
        
        let progressIndicator = app.activityIndicators["ProgressView"]
        XCTAssertTrue(progressIndicator.exists, "The progress indicator should appear when searching.")
    }
    func testImageGridUpdatesAfterSearch() {
        let app = XCUIApplication()
        app.launch()
        
        let searchBar = app.textFields["Search Flickr"]
        searchBar.tap()
        searchBar.typeText("mountains")
        
        // Allow some time for images to load (you might adjust this depending on your app's response time)
        let collectionView = app.collectionViews.firstMatch
        let imageCell = collectionView.cells.firstMatch
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: imageCell)
        let result = XCTWaiter().wait(for: [expectation], timeout: 5.0)
        
        XCTAssertEqual(result, .completed, "The grid should show image cells after performing a search.")
    }
}
