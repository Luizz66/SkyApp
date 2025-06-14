//
//  SkyAppModel.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//
import Foundation

struct WeatherData: Codable {
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let humidity: Int
    }
    
    struct Wind: Codable {
        let speed: Double
    }
    
    struct Rain: Codable {
        let one: Double
        //0 - 2.5 mm: leve
        //2.5 - 7.6 mm: moderada
        //>7.6 mm: forte
        //ex: 🌧️ Chuva moderada: 2.73 mm nas últimas 1h
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
