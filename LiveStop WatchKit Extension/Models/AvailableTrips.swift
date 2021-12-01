//
//  AvailableRoutes.swift
//  LiveStop WatchKit Extension
//
//  Created by Adrien Cantérot on 23/11/2021.
//

import Foundation

struct AvailableTrips {
    let stop: Stop
    let trips: [Trip]
    let routes: [Route]
    
    var tripsByRoute: [String: [Trip]] {
        Dictionary(grouping: trips, by: { $0.route.id })
    }
    
    static let rocheStopTrips = AvailableTrips(stop: .rocheStop, trips: [.line1toHospital, .line1toHospital, .line11toHome, .line1toHome], routes: [.line1, .line11])
}
