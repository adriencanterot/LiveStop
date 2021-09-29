//
//  Estimates.swift
//  Estimates
//
//  Created by Adrien Cantérot on 08/09/2021.
//

import Foundation

struct Arrivals: Codable {
    let realtime: [Arrival]
    let realtimeError: Bool
    let realtimeEmpty: Bool
}

struct Arrival: Codable, Identifiable {
    var id = UUID()
    var lineReference: String
    var line: Line
    var destinationName: String
    var aimedDepartureTime: Date
    var expectedDepartureTime: Date
    var realtime: Bool
    
    var intervalFromNow: TimeInterval {
        timeIntervalFromNow.duration
    }
    
    var timeIntervalFromNow: DateInterval {
        DateInterval(start: Date.now, end: expectedDepartureTime)
    }
    
    private enum CodingKeys: String, CodingKey {
        case lineReference = "lineRef"
        case line = "line"
        case destinationName = "destinationName"
        case aimedDepartureTime = "aimedDepartureTime"
        case expectedDepartureTime = "expectedDepartureTime"
        case realtime = "realtime"
    }
    
}
