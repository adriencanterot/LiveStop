//
//  Line.swift
//  Line
//
//  Created by Adrien Cantérot on 04/09/2021.

import Foundation
import UIKit

//favorite lines : 1, 11

struct Line: Identifiable, Codable, Hashable, Equatable {
    let id = UUID()
    var number: String
    var tint: String
    var axis: String
    
    var color: UIColor {
        let _color = HexColor(hex: tint)
        return UIColor(red: _color.red, green: _color.green, blue: _color.blue, alpha: 1.0)
    }
    
    static func == (lhs: Line, rhs: Line) -> Bool {
        return lhs.number == rhs.number
    }
    
    
    
    static let line11 = Line(number: "11", tint: "#90277D", axis: "Migné Rochereaux-Laborit/Mignaloux")
    
    static let line1 = Line(number: "1", tint: "#00A3DB", axis: "Milétrie Patis-Futuroscope LPI")
    
    enum CodingKeys: String, CodingKey {
        case tint = "color"
        case number = "lineId"
        case axis = "name"
    }
}
