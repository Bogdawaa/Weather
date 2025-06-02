//
//  MainPresenter.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 28.05.2025.
//

import Foundation

@MainActor
protocol MainPresenter {
    var view: MainViewController? { get set }
    var currentWeather: WeatherResponse? { get }
    
    func viewDidLoad()
}

final class MainPresenterImpl {
    
    // MARK: - Public Properties
    weak var view: MainViewController?
    
    // MARK: - Private Properties
    private let weatherService: WeatherService
    
    private(set) var forecastWeather: ForecastResponse?
    private(set) var currentWeather: WeatherResponse?
    private(set) var errorMessage: String?
    
    
    // MARK: - Init
    init (weatherService: WeatherService = WeatherServiceImpl(apiKey: "fa8b3df74d4042b9aa7135114252304")) {
        self.weatherService = weatherService
        viewDidLoad()
    }
    
    func viewDidLoad() {
        fetchCurrentWeater()
    }
}


// MARK: - MainPresenter Extension
extension MainPresenterImpl: MainPresenter {
    
    func fetchCurrentWeater() {
        Task { @MainActor in
            do {
                view?.showLoading()
                let forecastWeather = try await weatherService.getForecast(for: "Moscow", days: 3)
                view?.updateViewData(with: forecastWeather)
                view?.displayDailyForecast(forecastWeather.forecast.forecastday)
                
                if var hours = forecastWeather.forecast.forecastday.first?.hour {
                    hours = hours.filter { $0.isCurrentOrFuture() }
                    view?.displayHourlyForecast(hours)
                }
                view?.hideLoading()
            } catch {
                view?.hideLoading()
                errorMessage = "Невозможно получить текущий прогноз погоды. Ошибка: \(error)"
                view?.displayError(errorMessage ?? "")
            }
            
        }
    }
}
