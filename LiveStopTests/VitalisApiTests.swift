//
//  VitalisApiTests.swift
//  VitalisApiTests
//
//  Created by Adrien Cantérot on 15/09/2021.
//

import XCTest
@testable import LiveStop_WatchKit_Extension

class VitalisApiTests: XCTestCase {

    var api = VitalisApi()
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testURLComponents() throws {
        
        let components = VitalisApi.makeURLComponents(for: .tourJeanBernard)

        XCTAssertNotNil(components.url)
        XCTAssert(components.url!.absoluteString == "https://api.scoop.airweb.fr/gtfs/SIRI/getSIRIWithErrors.json?max=20&networks=%5B1%5D&stop=10219")
    }
    
    func testURLRequest() throws {
        var components = URLComponents(string: "https://api.scoop.airweb.fr/gtfs/SIRI/getSIRIWithErrors.json")!
        components.queryItems = [
            URLQueryItem(name: "max", value: "20"),
            URLQueryItem(name: "networks", value: "[1]"),
            URLQueryItem(name: "stop", value: Stop.tourJeanBernard.stopPoint)
            ]
        
        guard let url = components.url else { return }
        
        let urlRequest = api.makeURLRequest(for: url)
        
        let bearer = api.bearer
        
        XCTAssert(urlRequest.value(forHTTPHeaderField: "Authorization") == bearer.token)
    }
    
    func testLoadingDataForStop() throws {
        let expectation = XCTestExpectation(description: "Arrivals are downloaded")
        api.loadData(stop: .tourJeanBernard) { arrivals in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
    

}
