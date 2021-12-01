//
//  ArrivalLabel.swift
//  ArrivalLabel
//
//  Created by Adrien Cantérot on 14/09/2021.
//

import SwiftUI
import SwiftfulLoadingIndicators
import ClockKit

struct ArrivalLabel: View {
    
    var route: Trip
    @EnvironmentObject var modelData: ModelData
    var formatter: DateComponentsFormatter {
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.unitsStyle = .abbreviated
        timeFormatter.allowedUnits = [.minute]
        return timeFormatter
    }
    var body: some View {
        HStack {
            let line = route.route
            let color = HexColor(hex: line.colorString)
            LineBadge(number: line.shortName, tint: Color(red: color.red, green: color.green, blue: color.blue))
            Spacer()
            if let arrivalsForRoute = modelData.arrivals(for: route) {
                HStack {
                    ForEach(arrivalsForRoute.prefix(2)) { arrival in
                        Text(formatter.string(from: arrival.expectedDepartureTime.timeIntervalSinceNow) ?? "-")
                    }
                }
                
                LoadingIndicator(animation: .pulseOutlineRepeater, size: .small, speed: .slow)

            } else if modelData.arrivalByLine == nil {
                LoadingIndicator(animation: .bar, color: .white, size: .small, speed: .slow)
            } else if modelData.arrivalByLine!.count == 0 {
                Text("No buses")

            }

            
        }.padding(6)
    }
}

struct ArrivalLabel_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalLabel(route: .line1toHospital).environmentObject(ModelData())
    }
}
