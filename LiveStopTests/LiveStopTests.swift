//
//  LiveStopTests.swift
//  LiveStopTests
//
//  Created by Adrien Cantérot on 04/09/2021.
//

import XCTest
@testable import LiveStop_WatchKit_Extension

class LiveStopTests: XCTestCase {

    var data: Arrivals?
    
    override func setUpWithError() throws {
        data = try? loadData("liveData.json")

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDataExists() throws {
        XCTAssert(data?.realtime[0].lineReference == "114")
    }

}
