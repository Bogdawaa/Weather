//
//  LocationService.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 02.06.2025.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didFailWithError(error: Error)
    func didUpdateLocation(latitude: Double, longitude: Double)
}

final class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func requestLocation() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            delegate?.didFailWithError(error: NSError(
                domain: "Геолокация",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Отказано в доступе к геолокации"]
            ))
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        delegate?.didUpdateLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error: error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
}
