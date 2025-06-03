//
//  String+Extensions.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 03.06.2025.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: localized, arguments: arguments)
    }
}
