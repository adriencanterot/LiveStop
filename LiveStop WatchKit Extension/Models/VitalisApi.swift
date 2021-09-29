//
//  File.swift
//  File
//
//  Created by Adrien Cantérot on 15/09/2021.
//

import Foundation
import UIKit
import SwiftUI

class VitalisApi {
    
    struct Token: Codable {
        let token: String
    }
    
    enum ApiKeys: String {
        case stopPoint
        case max
        case networks
    }
    
    enum ApiError: Error {
        
        case needNewToken
        case unreachable
        case emptyData
        case badServerResponse
        case unhandledResponseType(Int)
    }
    
    var bearer: Token = Token(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJjbGllbnRfaWQiOiJzY29vcC53ZWIudml0YWxpcyIsImV4cGlyZXNfaW4iOjM2MDAsImlhdCI6MTYzMjA2ODA1NCwic2FsdCI6IkcoUH1lZ2M1VDYxWzxiX3kiLCJzY29wZSI6InNjb29wLmd0ZnMgc2Nvb3AubGluZS5yZWFkIHNjb29wLm5ldHdvcmsucmVhZCBzY29vcC5uZXdzLnJlYWQgc2Nvb3AucG9pLnJlYWQgc2Nvb3Auc3RvcC5yZWFkIHNjb29wLnRyYWZmaWMucmVhZCIsInR5cGUiOiJjbGllbnRfdG9rZW4ifQ.IvbvLhPk3x1Xh5H9Ld_LnB9CyIFKRr7jwvtsdbdDfEFhg4QdtXzMjjE4eYALw49f_G3vJXnVNyLTIaZjghYiZHyhEx3s0lrnDxQgD35ucv2yk6JShmloaaliy7s33SSuSYPlSs3IBsG9LSzhljj8aOxvi4h77m8Qr0XWK7AkGuIThPjE0lLmtTOAYzJGprtj98aSzjoXATjXQeY6u_Q7wKHnl-IW-Sj-0saL-tnBiCyTliGP1i1cYrR49N3zcXWz4EJiLLAMf_8jca1wWyT0w84v_H8Ojh1twtFLuG3gr3uI21P4HceLT7wx259if7CPgwwajbfvDkesW1yfJoZjiQppau4EC9K6z0zuPjlr62bPJDpV5zjrS979efiKTn3B6xiuNHGE1qmDDQX9oNcSVlAPZhCKE2Ovuu7XjFewiEf2Xd-XVkoSVZbSCqv3iuiz_7Iu9D_WqaCO90owPp6Z1I5HMzlSdLOFOsGHKqHhpj4uaQVYnshgckmzpj-ew98nLcg4aaMCzxIaxs8Q6d92FwYC8Q9GO8QxD0GrhTC1t7y1sHF0IAxc4VVNmbb1DX1-oWNqVA6AMAOihlkWCkrS8TLZpIMlaL49aoVUSPbl6XWJA7vd83CBYBrDRB_OZ-xLBDME21GkroTtCZfl6Mu9OXg1UVa8dn-EjH57KMSPH-4")
        
    var errorMessage: String?
    
    
    let session: URLSession
    var currentStop: Stop?
    
    public init() {

        session = URLSession.shared
    }
    
    static func makeURLComponents(for stop: Stop) -> URLComponents {
        var components = URLComponents(string: "https://api.scoop.airweb.fr/gtfs/SIRI/getSIRIWithErrors.json")!
        components.queryItems = [
            URLQueryItem(name: ApiKeys.max.rawValue, value: "20"),
            URLQueryItem(name: ApiKeys.networks.rawValue, value: "[1]"),
            URLQueryItem(name: ApiKeys.stopPoint.rawValue, value: stop.stopPoint)
        ]
        
        return components
        
    }
    
    func makeURLRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(self.bearer.token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func handleResponse<T>(response: URLResponse?, data: Data?, error: Error?, completionOnSuccess: @escaping (Data) throws -> T) throws -> T {
        guard error == nil else { throw error! }
        guard let httpResponse = response as? HTTPURLResponse else { throw VitalisApi.ApiError.badServerResponse }
        guard let data = data else { throw ApiError.emptyData }
        
        switch(httpResponse.statusCode) {
        case 401:
            throw ApiError.needNewToken
        case 200:
            return try completionOnSuccess(data)
        default:
            throw ApiError.unhandledResponseType(httpResponse.statusCode)
        }
        
    }
    
    func decodeArrivals(data: Data) throws -> [Arrival] {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let decodedData = try decoder.decode(Arrivals.self, from: data)
        return decodedData.realtime

    }
    
    func decodeToken(data: Data) throws -> Token {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(Token.self, from: data)
        return decodedData
    }
    
    func loadData(stop: Stop, completionOnSuccess: @escaping ([Arrival]) -> Void) {
        self.currentStop = stop
        let components = Self.makeURLComponents(for: stop)
        guard let url = components.url else { return }
        let request = makeURLRequest(for: url)
                
        let dataTask = session.dataTask(with: request) { data, response, error in
            do {
                let arrivals = try self.handleResponse(response: response, data: data, error: error, completionOnSuccess: self.decodeArrivals)
                DispatchQueue.main.async {
                    completionOnSuccess(arrivals)
                }

            } catch(ApiError.needNewToken) {
                print("Need new token")
                self.loadToken(stop: stop, completionOnSuccess: completionOnSuccess)
            } catch(ApiError.unhandledResponseType(let code)) {
                print("Bad response: \(String(code))")
            } catch(let defaultError) {
                print(defaultError.localizedDescription)
            }
            
        }
        dataTask.resume()
    }
    
    func loadToken(stop: Stop? = nil, completionOnSuccess: (([Arrival]) -> Void)? = nil) {
        let dataTask = session.dataTask(with: URL(string: "https://vitalisapitokenscraper-production.up.railway.app/token")!) { data, response, error in
            do {
                let token = try self.handleResponse(response: response, data: data, error: error, completionOnSuccess: self.decodeToken)
                self.bearer = token
                if let completionOnSuccess = completionOnSuccess, let stop = stop {
                    self.loadData(stop: stop, completionOnSuccess: completionOnSuccess)
                }
            } catch(let errorJson) {
                print(errorJson.localizedDescription)
            }
            
        }
        dataTask.resume()
    }
}
