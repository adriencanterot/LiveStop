//
//  HexColor.swift
//  HexColor
//
//  Created by Adrien Cantérot on 08/09/2021.
//

import Foundation
import UIKit
import SwiftUI

struct HexColor: Codable {
    
    let hex: String
    private var rgbValue: UInt64 {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if(cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if(cString.count != 6) {
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return rgbValue
    }
    
    var red: Double {
        Double((rgbValue & 0xFF0000) >> 16) / 255.0
    }
    var green: Double {
        Double((rgbValue & 0x00FF00) >> 8) / 255.0
    }
    var blue: Double {
        Double(rgbValue & 0x0000FF) / 255.0
    }
    
}

extension Color {
    public init(string: String) {
        let hexColor = HexColor(hex: string)
        let uiColor = UIColor(red: hexColor.red, green: hexColor.green, blue: hexColor.blue, alpha: 1.0)
        self.init(uiColor: uiColor)
        
    }
}
