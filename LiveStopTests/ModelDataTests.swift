//
//  ModelDataTests.swift
//  ModelDataTests
//
//  Created by Adrien Cantérot on 14/09/2021.
//

import XCTest
@testable import LiveStop_WatchKit_Extension

class ModelDataTests: XCTestCase {

    var data = ModelData()
    
    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoadTripsForStop() throws {
        let availableTrips = data.loadTripsFor(stop: .rocheStop)
        XCTAssert(availableTrips?.routes.count == 4)
    }
}
