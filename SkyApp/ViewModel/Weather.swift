//
//  Weather.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import CoreLocation
import SwiftUI

class Weather: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var forecastData: ForecastData?
    @Published var errorMessage: String?
    
    private let weatherService = WeatherService()
    
    func loadWeather(for coord: CLLocationCoordinate2D) {
        weatherService.fetchCurrentWeather(for: coord) { result in
            switch result {
            case .success(let dados):
                self.weatherData = dados
            case .failure(let erro):
                self.errorMessage = erro.localizedDescription
            }
        }
    }
    
    func loadForecast(for coord: CLLocationCoordinate2D) {
        weatherService.fetchForecast(for: coord) { result in
            switch result {
            case .success(let dados):
                self.forecastData = dados
            case .failure(let erro):
                self.errorMessage = erro.localizedDescription
            }
        }
    }
}

extension Weather {
    var todayMinMaxTemp: (min: String, max: String)? {
        
        guard let list = forecastData?.list else { return nil }
        
        let apiFormatter = DateFormatter()
        apiFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        apiFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        let today = Date()
        
        let todayForecasts = list.compactMap { item -> (Double, Double)? in
            guard let date = apiFormatter.date(from: item.dt_txt) else { return nil }
            if calendar.isDate(date, inSameDayAs: today) {
                return (item.main.temp_min, item.main.temp_max)
            }
            return nil
        }
        
        guard !todayForecasts.isEmpty else { return nil }
        
        let strMin = "Mín.: \(Int(todayForecasts.map { $0.0 }.min() ?? 0.0))°"
        let strMax = "Máx.: \(Int(todayForecasts.map { $0.1 }.max() ?? 0.0))°"
        
        return (strMin, strMax)
    }
}

extension Weather {
    var dailyForecasts: [DailyForecast] {
        guard let list = forecastData?.list else { return [] }
        
        let grouped = Dictionary(grouping: list) { forecast in
            String(forecast.dt_txt.prefix(10)) // yyyy-mm-dd
        }
        let sortedKeys = grouped.keys.sorted()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date())
        
        let nextDays = sortedKeys.filter { $0 > todayString }
        
        return nextDays.prefix(5).compactMap { date in
            guard let forecasts = grouped[date] else { return nil }
            
            let middayForecast = forecasts.first(where: { $0.dt_txt.contains("12:00:00") })
            
            let icon = middayForecast?.weather.first?.icon ?? forecasts.first?.weather.first?.icon ?? "01d"
            
            let minTemp = forecasts.map { $0.main.temp_min }.min() ?? 0.0
            let maxTemp = forecasts.map { $0.main.temp_max }.max() ?? 0.0
            
            return DailyForecast(
                date: formatDayWeek(from: date),
                icon: icon,
                tempMin: minTemp,
                tempMax: maxTemp
            )
        }
        
        func formatDayWeek(from dateString: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "pt_BR")
            
            guard let date = dateFormatter.date(from: dateString) else {
                return "--"
            }
            
            dateFormatter.dateFormat = "EEE"
            return dateFormatter.string(from: date).capitalized
        }
    }
}
