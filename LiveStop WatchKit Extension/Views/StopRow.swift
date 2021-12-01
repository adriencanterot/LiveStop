//
//  StopRow.swift
//  StopRow
//
//  Created by Adrien Cantérot on 08/09/2021.
//

import SwiftUI

struct StopRow: View {
    
    var stop: Stop
    var body: some View {
        HStack {
            Text(stop.name)
            if stop.isFavorite {
                Spacer()
                Image(systemName: "star.fill").foregroundColor(Color.yellow)
            }
        }
    }
}

struct StopRow_Previews: PreviewProvider {
    static var previews: some View {
        StopRow(stop: Stop.tourJeanBernard)
    }
}
