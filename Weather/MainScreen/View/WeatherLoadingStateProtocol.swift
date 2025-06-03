//
//  WeatherStateProtocol.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 03.06.2025.
//

import Foundation

protocol WeatherLoadingStateProtocol: AnyObject {
    var isRefreshing: Bool { get }
    
    func showLoading()
    func hideLoading()
    func endRefreshing()
}
