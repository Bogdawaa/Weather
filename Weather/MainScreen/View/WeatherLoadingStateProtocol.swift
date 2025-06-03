//
//  WeatherStateProtocol.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 03.06.2025.
//

import Foundation

protocol WeatherLoadingStateProtocol: AnyObject {
    func showLoading()
    func hideLoading()
}
