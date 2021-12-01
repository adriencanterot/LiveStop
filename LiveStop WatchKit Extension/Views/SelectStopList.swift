//
//  SelectStopList.swift
//  LiveStop WatchKit Extension
//
//  Created by Adrien Cantérot on 22/10/2021.
//

import SwiftUI

struct SelectStopList: View {
    
    @EnvironmentObject var modelData: ModelData
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            if let stops = modelData.loadCloseStops(filter: text, limit: 100) {
                List {
                     ForEach(stops) { stop in
                         NavigationLink(destination: AvailableTripsView(availableTrips: modelData.loadTripsFor(stop: stop)!)) {
                                StopRow(stop: stop)
                         }
                     }
                 }.searchable(text: $text)
            } else {
                Text("No Stops")
            }
        }

    }
}

struct SelectStopList_Previews: PreviewProvider {
    static var modelData = ModelData()
    static var previews: some View {
        SelectStopList().environmentObject(modelData)
    }
}
