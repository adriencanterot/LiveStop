//
//  Route.swift
//  Route
//
//  Created by Adrien Cantérot on 14/09/2021.
//

import Foundation

enum Direction: Int {
    case thisWay, thatWay
}

struct Trip: Identifiable {
    let id: String
    var route: Route
    var headSign: String
    var direction: Direction
    var isFavourite: Bool
    
    static var line11toHospital = Trip(id: "123", route: .line11, headSign: "Milétrie Laborit", direction: .thisWay, isFavourite: true)
    static var line1toHospital = Trip(id: "1234", route: .line1, headSign: "Milétrie Patis", direction: .thisWay, isFavourite: true)
    static var line11toHome = Trip(id: "12345", route: .line11, headSign: "Migne Rocheraux", direction: .thatWay, isFavourite: false)
    static var line1toHome = Trip(id: "123456", route: .line1, headSign: "Futuroscope", direction: .thatWay, isFavourite: false)
}

