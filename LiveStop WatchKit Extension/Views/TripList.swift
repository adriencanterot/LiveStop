//
//  RouteList.swift
//  LiveStop WatchKit Extension
//
//  Created by Adrien Cantérot on 26/10/2021.
//

import SwiftUI

struct TripList: View {
    var stop: Stop
    var route: Route
    var trips: [Trip]
    
    var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    LineBadge(number: route.shortName, tint: Color(string: route.colorString)).padding(1)
                    Text(route.longName).font(.caption2).lineLimit(3)
                }
                ForEach(trips) { trip in
                    TripView(trip: .constant(trip))
                }
            }
        }
    }

struct TripList_Preview: PreviewProvider {
    static var previews: some View {
        TripList(stop: .tourJeanBernard, route: .line1, trips: [.line1toHome, .line11toHome])
    }
}
