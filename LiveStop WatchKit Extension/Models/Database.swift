//
//  Database.swift
//  LiveStop WatchKit Extension
//
//  Created by Adrien Cantérot on 29/10/2021.
//

import Foundation
import SQLite

class Database {
    
    static var localPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    private var connection: Connection
    private let favoriteTripsTable = Table("favoriteTrips")
    
    private let id = Expression<Int>("id")
    private let stopId = Expression<String>("stop_id")
    private let tripId = Expression<String>("trip_id")
    
    private let gtfsDatabase: GTFSDatabase
    
    public init(path: String) throws {
        
       connection = try Connection(path)
       gtfsDatabase = try GTFSDatabase()
        
        try connection.run(favoriteTripsTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(stopId)
            t.column(tripId)
        })
    }
    
    func getFavoriteStops() throws -> [Stop] {
        
        let favoriteStopStatement = favoriteTripsTable.select(stopId).group(stopId)
        let favoriteStopsIds = Array(try connection.prepare(favoriteStopStatement))
        
        return try gtfsDatabase.favoriteStopsWith(ids: favoriteStopsIds.map { $0[stopId]})
    }
    
    func setFavouriteTrip(trip: Trip, at stop: Stop) throws {
        try connection.run(favoriteTripsTable.insert(stopId <- String(stop.id), tripId <- String(trip.id)))
    }
    
}
