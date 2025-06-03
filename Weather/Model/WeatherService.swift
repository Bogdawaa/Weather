//
//  WeatherService.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 02.06.2025.
//

import Foundation

protocol WeatherService {
    func getForecast(for location: String, days: Int, language: String) async throws -> ForecastResponse
    func getForecast(latitude: Double, longitude: Double, language: String) async throws -> ForecastResponse
    func getHourlyForecast(for location: String, days: Int, language: String) async throws -> [HourForecast]
}
