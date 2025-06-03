//
//  MainPresenter.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 28.05.2025.
//

import Foundation

final class MainPresenterImpl {
    
    // MARK: - Public Properties
    weak var view: MainViewProtocol?
    
    // MARK: - Private Properties
    private let weatherService: WeatherService
    private let locationManager: LocationManager
    
    private var defaultLocation: String = "Moscow"
    
    private(set) var forecastWeather: ForecastResponse?
    private(set) var currentWeather: WeatherResponse?
    private(set) var errorMessage: String?
    
    
    // MARK: - Init
    init (weatherService: WeatherService = WeatherServiceImpl(apiKey: "fa8b3df74d4042b9aa7135114252304"),
        locationManager: LocationManager = LocationManager()
    ) {
        self.weatherService = weatherService
        self.locationManager = locationManager
        
        // delegate
        locationManager.delegate = self
        
        viewDidLoad()
    }
    
    func viewDidLoad() {
        fetchWeatherForCurrentLocation()
    }
    
    func fetchWeatherForCurrentLocation() {
        view?.showLoading()
        locationManager.requestLocation()
    }
}


// MARK: - MainPresenter Extension
extension MainPresenterImpl: MainPresenter {
    func fetchCurrentWeater() {
        Task { @MainActor in
            do {
                // daily forecast
                view?.showLoading()
                let language = LanguageService.shared.weatherAPILanguageCode
                let forecastWeather = try await weatherService.getForecast(
                    for: defaultLocation,
                    days: 4,
                    language: language
                )
                view?.displayCurrentDayForecast(forecastWeather)
                view?.displayDailyForecast(forecastWeather.forecast.forecastday)
                
                // hourly forecast
                let allHours = try await weatherService.getHourlyForecast(
                    for: defaultLocation,
                    days: 2,
                    language: language
                )
                let filteredHours = allHours.filteredForCurrentAndNextDay()
                view?.displayHourlyForecast(filteredHours)
                
                view?.hideLoading()
            } catch {
                view?.hideLoading()
                errorMessage = "Невозможно получить текущий прогноз погоды. Ошибка: \(error)"
                view?.displayError(errorMessage ?? "")
            }
            
        }
    }
    
    func attachView(_ view: MainViewProtocol) {
        self.view = view
    }
}

// MARK: - LocationManagerDelegate Extension
extension MainPresenterImpl: LocationManagerDelegate {
    func didUpdateLocation(latitude: Double, longitude: Double) {
        defaultLocation = "\(latitude),\(longitude)"
        print("New location: \(defaultLocation)")
        fetchCurrentWeater()
    }
    
    func didFailWithError(error: Error) {
        print("Location error: \(error.localizedDescription)")
        errorMessage =  "Возникла ошибка при определении геолокации: \(error)"
        view?.displayError(errorMessage ?? "Возникла ошибка при определении геолокации")
        defaultLocation = "Moscow"
        fetchCurrentWeater()
    }
}
