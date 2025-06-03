//
//  WeatherAlertProtocol.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 03.06.2025.
//

import Foundation

protocol WeatherAlertProtocol: AnyObject {
    func displayError(_ message: String)
}
