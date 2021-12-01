//
//  SwiftUIView.swift
//  LiveStop WatchKit Extension
//
//  Created by Adrien Cantérot on 23/11/2021.
//

import SwiftUI

struct AvailableTripsView: View {
    
    var availableTrips: AvailableTrips
    
    var body: some View {
        List {
            ForEach(availableTrips.routes) { route in
                TripList(stop: availableTrips.stop, route: route, trips: availableTrips.tripsByRoute[route.id] ?? [])
            }
        }.listStyle(.elliptical)
        
    }
}

struct AvailableTripsView_Previews: PreviewProvider {
    static var previews: some View {
        AvailableTripsView(availableTrips: .rocheStopTrips)
    }
}
