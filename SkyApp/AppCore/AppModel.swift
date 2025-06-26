//
//  AppModel.swift
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
}

struct ForecastData: Codable {
    let list: [Forecast]
}

struct Forecast: Codable {
    let dt_txt: String
    let main: MainForecast
    let weather: [WeatherIcon]
}

struct MainForecast: Codable {
    let temp_min: Double
    let temp_max: Double
}

struct WeatherIcon: Codable {
    let icon: String
}

struct DailyForecast {
    let date: String
    let icon: String
    let tempMin: Double
    let tempMax: Double
}

//get apiKey
struct Secrets {
    static var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let apiKey = dict["API_KEY"] as? String else {
            fatalError("API Key não encontrada")
        }
        return apiKey
    }
}
