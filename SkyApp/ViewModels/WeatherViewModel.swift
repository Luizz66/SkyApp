//
//  WeatherViewModel.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var errorMessage: String?
    
    private let apiService = APIService()
    
    func loadWeather(for coord: CLLocationCoordinate2D) async {
        do {
            let dados = try await apiService.fetchCurrentWeather(for: coord)
            await MainActor.run {
                self.weatherData = dados
                self.errorMessage = nil
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.weatherData = nil
            }
        }
    }
}

struct WeatherFormat {
    static func temp(_ temp: Double) -> String {
        return String(format: "%.0f°", temp).dotToComma()
    }
    
    static func wind(_ wind: Double) -> String {
        return String(format: "%.1f km", wind * 3.6).lowercased().dotToComma()
    }
    
    static func precipatation(_ wind: Double?) -> String {
        return String(format: "%.1f mm", wind ?? 0).lowercased().dotToComma()
    }
    
    static func sys(_ sys: TimeInterval) -> String {
        let sysInterval = Date(timeIntervalSince1970: sys)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        
        return formatter.string(from: sysInterval) + " h"
    }
    
    static func mainDescription(_ description: String?) -> String {
        return description?.capitalized ?? "⚠️ Condição desconhecida"
    }
    
    static func sensationDescription(_ temp: Double, _ feelsLike: Double) -> String {
        let intTemp = Int(temp)
        let intFeelsLike = Int(feelsLike)
        
        if intFeelsLike < intTemp {
            return "A sensação térmica está mais baixa do que a temperatura real."
        }
        else if intFeelsLike > intTemp {
            return "A sensação térmica está mais alta do que a temperatura real."
        }
        else {
            return "A sensação térmica é semelhante à temperatura real."
        }
    }
}

extension String {
    func dotToComma() -> String {
        return self.replacingOccurrences(of: ".", with: ",")
    }
}
