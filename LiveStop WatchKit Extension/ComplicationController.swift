//
//  ComplicationController.swift
//  LiveStop WatchKit Extension
//
//  Created by Adrien Cantérot on 04/09/2021.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let data = ModelData.shared
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "Next Arrivals for Stop", displayName: "Arrivals", supportedFamilies: [.graphicCorner])
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        if data.closestStop != nil {
            let template = createTemplate(for: complication, complicationData: data.arrivalByLine)
            let entry = CLKComplicationTimelineEntry(date: Date.now, complicationTemplate: template)
            handler(entry)

        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let template = createTemplate(for: complication, complicationData: [:])
        handler(template)
    }
    
    private func createTemplate(for complication: CLKComplication, complicationData: [String: [Arrival]]?) -> CLKComplicationTemplate {
        switch complication.family {
        case .graphicCorner:
            return createGraphicCornerTextImageTemplate(complicationData: complicationData)
        default:
            return createGraphicCornerTextImageTemplate(complicationData: complicationData)
            
        }
    }
    
    struct ComplicationEstimate {
        var line: Line
        var arrival: Arrival?
    }
    
    private func makeInnerText(arrivals: [String: [Arrival]]?) -> CLKTextProvider {
        let defaultProvider = CLKSimpleTextProvider(text: "No Buses")
        guard let arrivals = arrivals else {
            return defaultProvider
        }
        
        var estimates: [ComplicationEstimate] = []
        for route in data.routes {
            if let arrivalsForRoute = arrivals[route.line.number]?.filter({ route.directions.contains($0.destinationName) }) {
                estimates.append(ComplicationEstimate(line: route.line, arrival: arrivalsForRoute.first))
            } else {
                print("No route for \(route.directions)")
            }
        }
        if estimates.count > 0 {
            let estimateLineNumber1 = CLKSimpleTextProvider(text: estimates[0].line.number)
            estimateLineNumber1.tintColor = estimates[0].line.color
            let estimateArrival1 = CLKRelativeDateTextProvider(date: estimates[0].arrival?.expectedDepartureTime ?? Date.now, style: .naturalAbbreviated, units: .minute)
            let estimateLineNumber2 = CLKSimpleTextProvider(text: estimates[1].line.number)
            estimateLineNumber2.tintColor = estimates[1].line.color
            let estimateArrival2 = CLKRelativeDateTextProvider(date: estimates[1].arrival?.expectedDepartureTime ?? Date.now, style: .naturalAbbreviated, units: .minute)
            
            return CLKTextProvider(format: "%@: %@ %@: %@", estimateLineNumber1, estimateArrival1, estimateLineNumber2, estimateArrival2)
        } else {
            return defaultProvider
        }

    }
    
    
    private func createGraphicCornerTextImageTemplate(complicationData: [String: [Arrival]]?) -> CLKComplicationTemplate {
        

        let innerTextProvider = makeInnerText(arrivals: complicationData)
        
        let template = CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: innerTextProvider, outerTextProvider: CLKSimpleTextProvider(text: data.closestStop?.shortName ?? "NC"))
        
        return template
    }
}
