//
//  DateConverter.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 02.06.2025.
//

import Foundation

extension DateFormatter {
    
    static let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: LanguageService.shared.currentLanguage)
        return formatter
    }()
    
    static let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h"
        formatter.locale = Locale(identifier: LanguageService.shared.currentLanguage)
        return formatter
    }()
}
