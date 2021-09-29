//
//  Stop.swift
//  Stop
//
//  Created by Adrien Cantérot on 04/09/2021.
//

import Foundation
import CoreLocation

//favorite stops: la roche/ tour jean bernard

struct Stop: Identifiable {
    var id: Int
    var name: String
    var shortName: String
    var location: CLLocationCoordinate2D
    var lines: [Line]
    var favouriteRoutes: [Route]
    var isFavorite: Bool
    var stopPoint: String
    
    static let rocheStop = Stop(id: 10820, name: "La Roche", shortName: "LR", location: CLLocationCoordinate2D(latitude: 46.588186, longitude: 00.330249), lines: [.line11, .line1], favouriteRoutes: [.line1toHospital, .line11toHospital], isFavorite: true, stopPoint: "10820")
    static let tourJeanBernard = Stop(id: 10219, name: "Tour Jean Bernard", shortName: "TJB", location: CLLocationCoordinate2D(latitude: 46.560487, longitude: 00.386888), lines: [.line11, .line1], favouriteRoutes: [.line1toHome, .line11toHome], isFavorite: true, stopPoint: "10219")
   
}
