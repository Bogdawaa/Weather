//
//  MainViewProtocol.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 02.06.2025.
//

import Foundation

protocol WeatherDisplayProtocol: AnyObject {
    func displayCurrentDayForecast(_ forecast: ForecastResponse)
    func displayDailyForecast(_ days: [ForecastDay])
    func displayHourlyForecast(_ hours: [HourForecast])
    func displayAdditionalSections(
        uvAndPressure: [WeatherItem],
        precipitation: [WeatherItem],
        wind: [WeatherItem]
    )
}
