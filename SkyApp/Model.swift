//
//  Model.swift
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
        let humidity: Int
    }
    
    struct Wind: Codable {
        let speed: Double
    }
    
    struct Weather: Codable {
        let main: String
        let description: String
    }
    
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
    
    let main: Main
    let wind: Wind
    let weather: [Weather]
    let coord: Coord
    let name: String
}
