//
//  StopView.swift
//  StopView
//
//  Created by Adrien Cantérot on 08/09/2021.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct StopView: View {
    var stop: Stop
    @EnvironmentObject var modelData: ModelData
    @Environment(\.scenePhase) private var scenePhase
    
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Divider()

            List {
                ForEach(stop.favouriteRoutes) { route in
                    ArrivalLabel(route: route)
                }
            }
            if modelData.requestInProgress {
                HStack {
                    Spacer()
                    LoadingIndicator(animation: .threeBallsBouncing, color: .white, size: .small, speed: .slow)
                    Spacer()
                }
            }

        }
        .navigationTitle(stop.name)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                if modelData.shouldMakeAnotherRequest { modelData.loadArrivals(for: stop) }
            default: break
            }
        }
        .onAppear {
            print("onAppear")
            if modelData.shouldMakeAnotherRequest { modelData.loadArrivals(for: stop) }
        }
    }
}

struct StopView_Previews: PreviewProvider {
    static var previews: some View {
        StopView(stop: .rocheStop).environmentObject(ModelData())
    }
}
