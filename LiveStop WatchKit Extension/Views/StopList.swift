//
//  StopList.swift
//  StopList
//
//  Created by Adrien Cantérot on 05/09/2021.
//

import SwiftUI

struct StopList: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                NavigationLink(destination: SelectStopList().environmentObject(modelData)) {
                    Image(systemName: "plus")
                }
                .frame(width: 45)
                .buttonBorderShape(.roundedRectangle(radius: 200))
            }
                Divider()
                List {
                    ForEach(modelData.inRangeStops) { stop in
                        NavigationLink(destination: StopView(stop: stop).environmentObject(modelData), isActive: $modelData.shouldTriggerSegue) {
                            StopRow(stop: stop)
                        }
                    }
                }
                .navigationTitle("Arrêts").navigationBarTitleDisplayMode(.inline)
                .onAppear { modelData.updateLocation() }
            }
    }
}

struct StopList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StopList().environmentObject(ModelData())
        }
    }
}
