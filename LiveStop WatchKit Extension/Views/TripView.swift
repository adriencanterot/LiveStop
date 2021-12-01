//
//  SwiftUIView.swift
//  LiveStop WatchKit Extension
//
//  Created by Adrien Cantérot on 26/10/2021.
//

import SwiftUI

struct TripView: View {
    @Binding var trip: Trip
    
    var body: some View {
        HStack {
            Text(trip.headSign).font(.caption)
            Spacer()
            Button(action: {
                trip.isFavourite.toggle()
                
            }) {
                if trip.isFavourite {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                } else {
                    Image(systemName: "star")
                }
            }
        }.padding()
    }
}

struct TripView_Previews: PreviewProvider {
    
    static var previews: some View {
        TripView(trip: .constant(.line1toHome))
    }
}
