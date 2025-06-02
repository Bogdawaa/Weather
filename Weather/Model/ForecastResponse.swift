//
//  ForecastResponse.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 28.05.2025.
//

import Foundation

struct ForecastResponse: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let dateEpoch: Int
    let day: DayForecast
    let hour: [HourForecast]
    
    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day, hour
    }
    
    var dayName: String {
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                guard let date = dateFormatter.date(from: date) else { return date }
        
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else {
            dateFormatter.dateFormat = "EE"
            return dateFormatter.string(from: date)
        }
    }
}

struct DayForecast: Codable {
    let maxtempC: Double
    let mintempC: Double
    let avgtempC: Double
    let dailyWillItRain: Int
    let dailyChanceOfRain: Int
    let dailyWillItSnow: Int
    let dailyChanceOfSnow: Int
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case avgtempC = "avgtemp_c"
        case dailyWillItRain = "daily_will_it_rain"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case dailyWillItSnow = "daily_will_it_snow"
        case dailyChanceOfSnow = "daily_chance_of_snow"
        case condition
    }
}


struct HourForecast: Codable {
    let timeEpoch: Int
    let time: String
    let tempC: Double
    let isDay: Int
    let condition: Condition
    let cloud: Int
    let feelslikeC: Double
    let heatindexC: Double
    let willItRain: Int
    let chanceOfRain: Int
    let willItSnow: Int
    let chanceOfSnow: Int
    
    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
        case cloud
        case feelslikeC = "feelslike_c"
        case heatindexC = "heatindex_c"
        case willItRain = "will_it_rain"
        case chanceOfRain = "chance_of_rain"
        case willItSnow = "will_it_snow"
        case chanceOfSnow = "chance_of_snow"
    }
    
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(timeEpoch))
    }
    
    func isCurrentOrFuture() -> Bool {
        return date >= Date().addingTimeInterval(-3600)
    }
}
