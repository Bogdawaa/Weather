//
//  WeatherService.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 28.05.2025.
//

import Foundation

final class WeatherServiceImpl: WeatherService {
    private let apiKey: String
    private let networkClient: NetworkClient

    init(apiKey: String, networkClient: NetworkClient = NetworkClientImpl()) {
        self.apiKey = apiKey
        self.networkClient = networkClient
    }
    
    func getForecast(for location: String, days: Int = 3) async throws -> ForecastResponse {
        let endpoint = Endpoint(
            path: "/forecast.json",
            method: .GET,
            queryParameters: [
                "key": apiKey,
                "q": location,
                "days": "\(days)",
                "aqi": "no",
            ],
            headers: ["Content-Type": "application/json"],
            body: nil
        )
        
        return try await networkClient.request(endpoint)
    }
    
    func getForecast(latitude: Double, longitude: Double) async throws -> ForecastResponse {
        let location = "\(latitude),\(longitude)"
        return try await getForecast(for: location)
    }
}
