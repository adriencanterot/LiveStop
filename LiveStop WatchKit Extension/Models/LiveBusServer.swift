//
//  LiveBusServer.swift
//  LiveBusServer
//
//  Created by Adrien Cantérot on 05/09/2021.
//

import Foundation


struct Response {
    var timestamp: Int
    var stop: Stop
    var arrivals: [Arrivals]

}

protocol LiveBusServer {
    
    func request(stop: Stop, lines: [Line], date: Date) -> Response
}
