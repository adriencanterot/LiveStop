//
//  ComplicationView.swift
//  LiveStop WatchKit Extension
//
//  Created by Adrien Cantérot on 22/09/2021.
//

import SwiftUI
import ClockKit


struct ComplicationViewGraphicStackedText: View {
    
    var stop: Stop
    var arrivals: [String: [Arrival]]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ComplicationView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        Group {
            CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: CLKRelativeDateTextProvider(date: Date(timeIntervalSinceNow: 60*7), style: .naturalAbbreviated, units: .minute), outerTextProvider: CLKSimpleTextProvider(text: "TJB")).previewContext()
        }
    }
}
