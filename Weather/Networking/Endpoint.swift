//
//  Endpoint.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 28.05.2025.
//

import Foundation

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let queryParameters: [String: String]?
    let headers: [String: String]?
    let body: Encodable?
    
    var url: URL? {
        
        guard !path.isEmpty else {
            print("Error: Path is empty")
            return nil
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weatherapi.com"
        components.path = "/v1" + path
        
        if let queryParameters = queryParameters {
            components.queryItems = queryParameters.map {
                URLQueryItem(
                    name: $0.key,
                    value: $0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                )
            }
        }
        
        guard let url = components.url else {
            print("Failed to create URL from components:")
            print("- Scheme: \(components.scheme ?? "nil")")
            print("- Host: \(components.host ?? "nil")")
            print("- Path: \(components.path)")
            print("- QueryItems: \(components.queryItems?.description ?? "none")")
            return nil
        }
        
        return url
    }
}
