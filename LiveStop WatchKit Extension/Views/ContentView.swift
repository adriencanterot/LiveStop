//
//  ContentView.swift
//  LiveStop WatchKit Extension
//
//  Created by Adrien Cantérot on 04/09/2021.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        StopList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData())
    }
}
