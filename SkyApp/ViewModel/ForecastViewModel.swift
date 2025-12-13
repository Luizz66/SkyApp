//
//  ForecastViewModel.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 27/09/25.
//

import CoreLocation

class ForecastViewModel: ObservableObject {
    @Published var forecastData: ForecastData?
    @Published var errorMessage: String?
    
    private let apiService = APIService()
    
    func loadForecast(for coord: CLLocationCoordinate2D) async {
        do {
            let dados = try await apiService.fetchForecast(for: coord)
            await MainActor.run {
                self.forecastData = dados
                self.errorMessage = nil
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.forecastData = nil
            }
        }
    }
    
    // computed property
    var todayMinMaxTemp: (min: String, max: String)? {
        guard let list = forecastData?.list else { return nil }
        
        let apiFormatter = DateFormatter()
        apiFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        apiFormatter.timeZone = TimeZone(secondsFromGMT: 0) // API vem em UTC
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current // use o fuso do usuário
        
        let today = Date()
        
        let todayForecasts = list.compactMap { item -> (Double, Double)? in
            guard let dateUTC = apiFormatter.date(from: item.dt_txt) else { return nil }
            
            // converter a data UTC para local
            let localDate = dateUTC.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
            
            if calendar.isDate(localDate, inSameDayAs: today) {
                return (item.main.temp_min, item.main.temp_max)
            }
            return nil
        }
        
        guard !todayForecasts.isEmpty else { return nil }
        
        let minTemp = todayForecasts.map { $0.0 }.min() ?? 0.0
        let maxTemp = todayForecasts.map { $0.1 }.max() ?? 0.0
        
        let strMin = "Mín.: \(Int(minTemp))°"
        let strMax = "Máx.: \(Int(maxTemp))°"
        
        return (strMin, strMax)
    }
    
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
            
            let weekday = formatDayWeek(from: date)
            let realDate = isTomorrow(weekday) ? "Amanhã" : weekday
            
            return DailyForecast(
                date: realDate,
                icon: icon,
                tempMin: minTemp,
                tempMax: maxTemp
            )
        }
    }
    
    private func formatDayWeek(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        
        guard let date = dateFormatter.date(from: dateString) else {
            return "--"
        }
        
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date).capitalized
    }
    
    private func isTomorrow(_ weekdayAbbrev: String) -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "EEE"
        
        guard let date = formatter.date(from: weekdayAbbrev) else {
            return false
        }
        
        let calendar = Calendar.current
        let targetWeekday = calendar.component(.weekday, from: date)
        
        let todayWeekday = calendar.component(.weekday, from: Date())
        
        let nextWeekday = todayWeekday % 7 + 1
        
        return targetWeekday == nextWeekday
    }
}

extension DailyForecast {
    // computed property
    var formattedTemp: (min: String, max: String) {
        return ("\(Int(tempMin))°", "\(Int(tempMax))°")
    }
    
    var mySFSymbol: String {
        return Symbol().SFSymbols[icon] ?? "circle.badge.questionmark.fill"
    }
}
