//
//  LanguageService.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 03.06.2025.
//

import Foundation

enum UserDefaultsKeys: String {
    case appLanguage = "appLanguage"
}

final class LanguageService {
    static let shared = LanguageService()
    
    private init() {}
    
    var currentLanguage: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.appLanguage.rawValue) ??
                   Locale.preferredLanguages.first?.prefix(2).description ?? "en"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.appLanguage.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var weatherAPILanguageCode: String {
        switch currentLanguage {
        case "ru":
            return "ru"
        default:
            return "en"
        }
    }
}
