//
//  Array+Extensions.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 03.06.2025.
//

import Foundation

extension Array where Element == HourForecast {
    
    func filteredForCurrentAndNextDay() -> [HourForecast] {
        let calendar = Calendar.current
        let now = Date()
        
        let currentHour = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        guard let currentHourStart = calendar.date(from: currentHour) else {
            return []
        }
        
        guard let nextDayStart = calendar.date(byAdding: .day, value: 1, to: now) else {
            return []
        }
        let nextDayComponents = calendar.dateComponents([.year, .month, .day], from: nextDayStart)
        guard let nextDayMidnight = calendar.date(from: nextDayComponents) else {
            return []
        }
        
        guard let nextDayEnd = calendar.date(byAdding: .day, value: 1, to: nextDayMidnight) else {
            return []
        }
        
        return self.filter { hour in
            let hourDate = Date(timeIntervalSince1970: TimeInterval(hour.timeEpoch))
            return hourDate >= currentHourStart && hourDate < nextDayEnd
        }
    }
}
