//
//  ModelData.swift
//  ModelData
//
//  Created by Adrien Cantérot on 04/09/2021.
//

import Foundation
import CoreLocation
import SwiftUI
import ClockKit

final class ModelData: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = ModelData()
    
    var locationManager: CLLocationManager
    let lines: [Line]
    private let stops: [Stop]
    let routes: [Route]
    private var lastRequest: Date
    var shouldMakeAnotherRequest: Bool {
        return abs(lastRequest.timeIntervalSinceNow) >= 90
    }
    
    @Published private var arrivals: [Arrival]? {
        didSet {
            let server = CLKComplicationServer.sharedInstance()
            for complication in server.activeComplications ?? [] {
                server.reloadTimeline(for: complication)
            }
        }
    }
    @Published var requestInProgress: Bool =  false
    var arrivalByLine: [String: [Arrival]]? {
        guard let arrivals = arrivals else {
            return nil
        }

        let arrivalDictionnary: [String: [Arrival]] = Dictionary(grouping: arrivals, by: { $0.line.number })
        return arrivalDictionnary
    }
    
    @Published var inRangeStops: [Stop]
    var closestStop: Stop? {
        inRangeStops.first
    }
    
    var vitalisApi: VitalisApi
    @Published var shouldTriggerSegue: Bool
    
    override public init() {
        
        locationManager = CLLocationManager()
        
        stops = [.tourJeanBernard, .rocheStop]
        lines = [.line1, .line11]
        routes = [.line1toHome, .line11toHome, .line1toHospital, .line11toHospital]
        arrivals = nil
        inRangeStops = stops
        vitalisApi = VitalisApi()
        lastRequest = Date.distantPast
        shouldTriggerSegue = false
        
        super.init()
        
        vitalisApi.loadToken()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
    }
    
    func updateLocation() {
        locationManager.requestLocation()
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            updateInRangeStops(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did fail with error \(error.localizedDescription)")
        
    }
    
    func loadArrivals(for stop: Stop) {
        self.requestInProgress = true
        vitalisApi.loadData(stop: stop) { arrivals in
            self.arrivals = arrivals
            self.requestInProgress = false
            self.lastRequest = Date.now
        }
    }
    
    
    func arrivals(for route: Route) -> [Arrival]? {
        return arrivalByLine?[route.line.number]?.filter { route.directions.contains($0.destinationName)}
    }
    
    
    private func updateInRangeStops(location: CLLocation) {
        self.shouldTriggerSegue = false
        inRangeStops = stops.filter { stop in
            let stopLocation = CLLocation(coordinates: stop.location)
            let location = locationManager.location ?? CLLocation(latitude: 46.5592671, longitude: 0.3814136)
            return stopLocation.distance(from: location) < 500
        }
        
        if inRangeStops.count == 1 {
            self.shouldTriggerSegue = true
        }
        
        if inRangeStops.count == 0 {
            inRangeStops = stops
        }
    }
    
    var mockComplicationData: [String: [Arrival]] {
        return ["1": [
            Arrival(lineReference: "156", line: .line1, destinationName: "Milétrie Patis", aimedDepartureTime: Date.init(timeIntervalSinceNow: 5*60), expectedDepartureTime: Date(timeIntervalSinceNow: 6*60), realtime: true),
            Arrival(lineReference: "156", line: .line1, destinationName: "Milétrie Patis", aimedDepartureTime: Date.init(timeIntervalSinceNow: 8*60), expectedDepartureTime: Date(timeIntervalSinceNow: 9*60), realtime: true)
        ],
                "11": [
                    Arrival(lineReference: "156", line: .line11, destinationName: "Milétrie Laborit", aimedDepartureTime: Date.init(timeIntervalSinceNow: 5*60), expectedDepartureTime: Date(timeIntervalSinceNow: 6*60), realtime: true),
                    Arrival(lineReference: "156", line: .line11, destinationName: "Milétrie Laborit", aimedDepartureTime: Date.init(timeIntervalSinceNow: 12*60), expectedDepartureTime: Date(timeIntervalSinceNow: 14*60), realtime: true)
                ]
        ]
    }

    
}

func loadData<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find file for filename provided")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't decode \(filename) as \(T.self):\n\(error)")
    }
}
