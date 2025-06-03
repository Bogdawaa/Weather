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
    
    func getForecast(latitude: Double, longitude: Double, language: String) async throws -> ForecastResponse {
        let location = "\(latitude),\(longitude)"
        return try await getForecast(for: location, language: language)
    }
    
    func getForecast(for location: String, days: Int = 3, language: String = "ru") async throws -> ForecastResponse {
        let endpoint = Endpoint(
            path: "/forecast.json",
            method: .GET,
            queryParameters: [
                "key": apiKey,
                "q": location,
                "days": "\(days)",
                "aqi": "no"
            ],
            headers: ["Content-Type": "application/json"],
            body: nil,
            language: language
        )
        
        return try await networkClient.request(endpoint)
    }
    
    func getHourlyForecast(for location: String, days: Int = 2, language: String = "ru") async throws -> [HourForecast] {
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
            body: nil,
            language: language
        )
        
        let response: ForecastResponse = try await networkClient.request(endpoint)
        return response.forecast.forecastday.flatMap { $0.hour }
    }
}
