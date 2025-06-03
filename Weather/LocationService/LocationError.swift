//
//  LocationError.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 02.06.2025.
//

import Foundation

enum LocationError: Error {
    case networkFailure
    case locationUnknown
    case locationServicesDisabled
    case permissionDenied
}
