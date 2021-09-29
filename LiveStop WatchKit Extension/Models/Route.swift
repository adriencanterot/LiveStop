//
//  Route.swift
//  Route
//
//  Created by Adrien Cantérot on 14/09/2021.
//

import Foundation

struct Route: Identifiable {
    let id = UUID()
    var line: Line
    var directions: [String]
    
    static var line11toHospital = Route(line: .line11, directions: ["Milétrie Laborit", "Rue des Artisans"])
    static var line1toHospital = Route(line: .line1, directions: ["Milétrie Patis"])
    static var line11toHome = Route(line: .line11, directions: ["Migné Rochereaux", "Stade Auxances"])
    static var line1toHome = Route(line: .line1, directions: ["Futuroscope LPI"])
}
