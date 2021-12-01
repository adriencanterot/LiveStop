//
//  DatabaseTsts.swift
//  LiveStopTests
//
//  Created by Adrien Cantérot on 16/10/2021.
//

import Foundation

import XCTest

@testable import LiveStop_WatchKit_Extension
import CoreLocation

class GTFSDatabaseTest: XCTestCase {

    var gtfsDatabase: GTFSDatabase?
    
    override func setUpWithError() throws {
        gtfsDatabase = try GTFSDatabase()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testGetClosestStops() throws {
        let tourJeanBernardCoordinates = CLLocationCoordinate2D(latitude: 46.560487, longitude: 0.386888)
        let limit = 100

        let stops = try gtfsDatabase?.getClosestStops(coordinates: tourJeanBernardCoordinates, limit: limit)
        
        XCTAssert(stops?.first?.name == "Tour Jean Bernard")
        XCTAssert(stops?.count == limit)
    }

    func testGetRoutesForStop() throws {
        let stop: Stop = .tourJeanBernard
        //let availableLinesAtStopTourJeanBernard =
        let availableTrips = try gtfsDatabase?.getTripsFromStop(stop)
        if let availableTrips = availableTrips {
            let availableRoutes = availableTrips.trips.map { $0.route.shortName }
            XCTAssert(availableTrips.trips[0].route.shortName == "13" && availableTrips.trips[0].headSign.count == 2)
            XCTAssert(availableRoutes.count == 44)
        } else {
            XCTFail()
        }
        
    }
    
    func testFavoriteStopsWithIds() throws {
        let stops = try gtfsDatabase?.favoriteStopsWith(ids: ["10820", "10219"])
        
        XCTAssert(stops != nil)
        XCTAssert(stops![1].name == "La Roche")
        XCTAssert(stops![0].name == "Tour Jean Bernard")
    }

    
}
