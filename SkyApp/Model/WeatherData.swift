//
// WeatherData.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import Foundation

struct WeatherData: Codable {
    struct Main: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
        let feels_like: Double
        let humidity: Int
    }
    
    struct Wind: Codable {
        let speed: Double
    }
    
    struct Rain: Codable {
        let one: Double
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct Sys: Codable {
        let sunrise: TimeInterval
        let sunset: TimeInterval
    }
    
    struct Weather: Codable {
        let id: Int
        let icon: String
    }
    
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
    
    let main: Main
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let sys: Sys
    let weather: [Weather]
    let coord: Coord
    let name: String
    
    //computed property
    var formattedTemp: (mainTemp: String, feelsLike: String) {
        let formattedT = String(format: "%.1f°", main.temp).replacingOccurrences(of: ".", with: ",")
        let formattedFL = String(format: "%.1f°", main.feels_like).replacingOccurrences(of: ".", with: ",")
        
        let tempStr = formattedT.last == "0" ? "\(Int(main.temp))°" : formattedT
        let feelsLikeStr = formattedFL.last == "0" ? "\(Int(main.feels_like))°" : formattedFL
        
        return (tempStr, feelsLikeStr)
    }
    
    var formattedWind: String {
        String(format: "%.1f km/h", wind.speed * 3.6).replacingOccurrences(of: ".", with: ",")
    }
    
    var formattedPrecipitation: String {
        String(format: "%.1f mm" , rain?.one ?? 0).replacingOccurrences(of: ".", with: ",")
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
