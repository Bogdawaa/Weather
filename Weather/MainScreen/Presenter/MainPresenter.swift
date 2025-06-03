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
    private var isRefreshing = false
    
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
            defer {
                isRefreshing = false
                view?.endRefreshing()
            }
            
            do {
                // daily forecast
                if view?.isRefreshing == false {
                    view?.showLoading()
                }
                
                let language = LanguageService.shared.weatherAPILanguageCode
                let forecastWeather = try await weatherService.getForecast(
                    for: defaultLocation,
                    days: 4,
                    language: language
                )
                view?.displayCurrentDayForecast(forecastWeather)
                view?.displayDailyForecast(forecastWeather.forecast.forecastday)
                
                processAdditionalWeatherItems(forecastWeather)
                
                // hourly forecast
                let allHours = try await weatherService.getHourlyForecast(
                    for: defaultLocation,
                    days: 2,
                    language: language
                )
                let filteredHours = allHours.filteredForCurrentAndNextDay()
                view?.displayHourlyForecast(filteredHours)
                
                view?.hideLoading()
                view?.endRefreshing()
            } catch {
                view?.hideLoading()
                view?.endRefreshing()
                errorMessage = "Невозможно получить текущий прогноз погоды. Ошибка: \(error)"
                view?.displayError(errorMessage ?? "")
            }
            
        }
    }
    
    func attachView(_ view: MainViewProtocol) {
        self.view = view
    }
    
    func didPullToRefresh() {
        guard !isRefreshing else { return }
        isRefreshing = true
        locationManager.requestLocation()
    }
    
    func processAdditionalWeatherItems(_ weather: ForecastResponse) {
        print(weather)
            let uvAndPressureSection = [
                WeatherItem(
                    title: "uv index".localized,
                    value: "\(weather.current.uv)",
                    iconName: "sun.max"
                ),
                WeatherItem(
                    title: "pressure".localized,
                    value: "\(weather.current.pressureMb)" + "millibars".localized,
                    iconName: "barometer"
                )
            ]
            
            let precipitationSection = [
                WeatherItem(
                    title: "chance of rain".localized,
                    value: "\(weather.forecast.forecastday.first?.day.dailyChanceOfRain ?? 0)%",
                    iconName: "cloud.rain"
                ),
                WeatherItem(
                    title: "chance of snow".localized,
                    value: "\(weather.forecast.forecastday.first?.day.dailyChanceOfSnow ?? 0)%",
                    iconName: "cloud.snow"
                )
            ]
            
            let windSection = [
                WeatherItem(
                    title: "wind speed".localized,
                    value: "\(weather.current.windKph)" + "km h".localized,
                    iconName: "wind"
                ),
                WeatherItem(
                    title: "wind direction".localized,
                    value: "\(weather.current.windDegree)°",
                    iconName: "location.north"
                )
            ]
            
            view?.displayAdditionalSections(
                uvAndPressure: uvAndPressureSection,
                precipitation: precipitationSection,
                wind: windSection
            )
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
