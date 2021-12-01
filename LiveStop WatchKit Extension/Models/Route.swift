//
//  Line.swift
//  Line
//
//  Created by Adrien Cantérot on 04/09/2021.

import Foundation
import UIKit

//favorite lines : 1, 11

struct Route: Identifiable, Codable, Hashable, Equatable {
    let id: String
    let shortName: String
    let colorString: String
    let longName: String
    
    var color: UIColor {
        let _color = HexColor(hex: colorString)
        return UIColor(red: _color.red, green: _color.green, blue: _color.blue, alpha: 1.0)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.shortName == rhs.shortName
    }
    
    static let line11 = Route(id: "1", shortName: "11", colorString: "#90277D", longName: "Migné Rochereaux-Laborit/Mignaloux")
    
    static let line1 = Route(id: "1", shortName: "1", colorString: "#00A3DB", longName: "Milétrie Patis-Futuroscope LPI")
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case colorString = "color"
        case shortName = "lineId"
        case longName = "name"
    }
}
