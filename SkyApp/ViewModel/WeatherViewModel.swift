//
//  Weather.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import CoreLocation
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var errorMessage: String?
    
    private let apiService = APIService()
    
    func loadWeather(for coord: CLLocationCoordinate2D) {
        apiService.fetchCurrentWeather(for: coord) { result in
            switch result {
            case .success(let dados):
                self.weatherData = dados
            case .failure(let erro):
                self.errorMessage = erro.localizedDescription
            }
        }
    }
}

extension WeatherData {
    // computed property
    var formattedTemp: (mainTemp: String, feelsLike: String) {
        let tempStr = String(format: "%.0f°", main.temp).dotToComma()
        let feelsLikeStr = String(format: "%.0f°", main.feels_like).dotToComma()
        
        return (tempStr, feelsLikeStr)
    }
    
    var formattedWind: String {
        String(format: "%.1f km", wind.speed * 3.6).dotToComma()
    }
    
    var formattedPrecipitation: String {
        String(format: "%.1f mm" , rain?.one ?? 0).dotToComma()
    }
    
    var formattedSys: (sunrise: String, sunset: String) {
        let sunrise = Date(timeIntervalSince1970: sys.sunrise)
        let sunset = Date(timeIntervalSince1970: sys.sunset)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        
        let formattedSunrise = formatter.string(from: sunrise) + " h"
        let formattedSunset = formatter.string(from: sunset) + " h"
        
        return (formattedSunrise, formattedSunset)
    }
    
    var mainDescription: String {
        return Legend().descriptionMap[weather.first?.id ?? 0] ?? "Condição desconhecida"
    }
    
    var sensationDescription: String {
        let intTemp = Int(main.temp)
        let intFeelsLike = Int(main.feels_like)
        
        if intFeelsLike < intTemp {
            return "A sensação térmica está mais baixa do que a temperatura real."
        }
        else if intFeelsLike > intTemp {
            return "A sensação térmica está mais alta do que a temperatura real."
        }
        else {
            return "Similar à temperatura real."
        }
    }
    
    var mySFSymbol: String {
        return Legend().SFSymbols[weather[0].icon] ?? "circle.badge.questionmark.fill"
    }
}

extension String {
    func dotToComma() -> String {
        return self.replacingOccurrences(of: ".", with: ",")
    }
}
