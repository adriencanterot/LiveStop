//
//  CLLocation+Coordinates.swift
//  CLLocation+Coordinates
//
//  Created by Adrien Cantérot on 14/09/2021.
//

import CoreLocation

extension CLLocation {
    convenience init(coordinates: CLLocationCoordinate2D) {
        self.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}
