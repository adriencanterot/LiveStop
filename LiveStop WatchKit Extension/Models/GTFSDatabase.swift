//
//  db.swift
//  LiveStop WatchKit Extension
//
//  Created by Adrien Cantérot on 16/10/2021.
//

import Foundation
import SQLite
import CoreLocation

enum DatabaseError: Error {
    case defaultError(String)
    case notConnected
}



class GTFSDatabase {
    
    private var connection: Connection?
    
    private let stopsTable = Table("gtfs_stops")
    private let routesTable = Table("gtfs_routes")
    private let tripsTable = Table("gtfs_trips")
    private let stopsTimeTable = Table("gtfs_stop_times")
    
    private let id = Expression<Int>("id")
    private let stopId = Expression<String>("stop_id")
    private let name = Expression<String>("stop_name")
    private let latitude = Expression<Double>("stop_lat")
    private let longitude = Expression<Double>("stop_lon")
    private let routeId = Expression<String>("route_id")
    private let routeShortName = Expression<String>("route_short_name")
    private let routeLongName = Expression<String>("route_long_name")
    private let tripId = Expression<String>("trip_id")
    private let directionId = Expression<Int>("direction_id")
    private let routeColor = Expression<String>("route_color")
    private let tripHeadsign = Expression<String>("trip_headsign")
    private let stopsLat = Expression<Double>("stop_lat")
    private let stopsLon = Expression<Double>("stop_lon")
    
    public init() throws {
        let path = Bundle.main.path(forResource: "poitiers_gtfs", ofType: "db")
        connection = try Connection(path!, readonly: true)
    }
    
    public func getClosestStops(filter:String = "", coordinates: CLLocationCoordinate2D?, limit: Int) throws -> [Stop] {
        
        guard let connection = connection else {
            throw DatabaseError.notConnected
        }
        
        var statement = stopsTable
            .select([stopId, name, stopsLat, stopsLon])
            .group(name)
        
        if coordinates != nil {
            statement = statement.order(
                (stopsTable[stopsLat] - coordinates!.latitude).absoluteValue + (stopsTable[stopsLon] - coordinates!.longitude).absoluteValue
            )
        }
        
        if filter != "" {
            statement = statement.where(name.like("%\(filter)%"))
        }
        
        statement = statement.limit(limit)
        
        print(statement.asSQL())
        
        return try connection.prepare(statement).map { row in
            return Stop(id: Int(row[self.stopId]) ?? -1,
                            name: row[self.name],
                               shortName: "SN",
                               location: CLLocationCoordinate2D(
                                   latitude: row[stopsLat],
                                   longitude: row[stopsLon]),
                               lines: [],
                               favouriteRoutes: [],
                               isFavorite: false,
                        stopPoint: row[self.stopId])
        }
    }
    
    public func getTripsFromStop(_ stop: Stop) throws -> AvailableTrips {
        guard let connection = connection else { throw DatabaseError.notConnected }
        
        let statement = stopsTable
            .select(
                [stopsTable[stopId],
                 stopsTable[name],
                 routesTable[routeId],
                 routesTable[routeShortName],
                 routesTable[routeLongName],
                 routesTable[routeColor],
                 tripsTable[tripId],
                 tripsTable[tripHeadsign],
                 tripsTable[directionId]])
            .join(.inner, stopsTimeTable, on: stopsTimeTable[stopId] == stopsTable[stopId])
            .join(.inner, tripsTable, on: tripsTable[tripId] == stopsTimeTable[tripId])
            .join(.inner, routesTable, on: routesTable[routeId] == tripsTable[routeId])
            .group(tripsTable[tripHeadsign], tripsTable[directionId])
            .where(stopsTable[name] == stop.name)
        
        let rows = Array(try connection.prepare(statement))
        
        var trips: [Trip] = []
        var routes: [Route] = []
        for row in rows {
            let route = Route(id: row[routeId], shortName: row[routeShortName], colorString: row[routeColor], longName: row[routeLongName])
            let trip = Trip(id: row[tripId], route: route , headSign: row[tripHeadsign], direction: Direction(rawValue: row[directionId])!, isFavourite: false)
            trips.append(trip)
            if(!routes.contains(route)) {
                routes.append(route)
            }
        }
            
        let availableTrips = AvailableTrips(stop: stop, trips: trips, routes: routes)
        return availableTrips;
        
    }
    
    func favoriteStopsWith(ids: [String]) throws -> [Stop] {
        guard let connection = connection else { throw DatabaseError.notConnected }

        let statement = stopsTable.select(stopId, name, latitude, longitude)
            .filter(ids.contains(stopId))
        
        let rows = Array(try connection.prepare(statement))
        return rows.map { row in Stop(row: row) }
    }
    
}

extension Stop {
    public init(row: Row) {
        let stopId = Expression<String>("stop_id")
        let stopName = Expression<String>("stop_name")
        
        let latitude = Expression<Double>("stop_lat")
        let longitude = Expression<Double>("stop_lon")
        
        self.init(id: Int(row[stopId]) ?? -1,
                    name: row[stopName],
                       shortName: "SN",
                       location: CLLocationCoordinate2D(
                           latitude: row[latitude],
                           longitude: row[longitude]),
                       lines: [],
                       favouriteRoutes: [],
                       isFavorite: false,
                stopPoint: row[stopId])
   
    }
}
    

