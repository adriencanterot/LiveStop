//
//  DatabaseTests.swift
//  LiveStopTests
//
//  Created by Adrien Cantérot on 29/10/2021.
//


import XCTest
@testable import LiveStop_WatchKit_Extension

import Foundation
import CoreLocation
import SQLite

class DatabaseTest: XCTestCase {

    let testPath = "\(Database.localPath)/test.sqlite3"
    
    var database: Database?
    var connection: Connection?
    
    var favoriteTripsTable = Table("favoriteTrips")
    
    var stopId = Expression<String>("stop_id")
    var tripId = Expression<String>("trip_id")
    
    override func setUpWithError() throws {
        
        database = try Database(path: testPath)
        connection = try Connection(testPath)
        
        if let connection = connection {
            try connection.run(favoriteTripsTable.insert(tripId <- "10820", stopId <- "10820"))
        }
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try FileManager.default.removeItem(at: URL(fileURLWithPath: testPath))
        
    }
    
    func testTableExist() throws {
        guard let connection = connection else { throw DatabaseError.notConnected }
        let _ = try connection.prepare(favoriteTripsTable)
    }
    
    func testGetFavoriteStops() throws {
        guard let database = database else { throw DatabaseError.notConnected }
        let stops = try database.getFavoriteStops()
        print(stops)

    }
}

