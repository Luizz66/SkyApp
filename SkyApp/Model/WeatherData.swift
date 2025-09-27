//
//  WeatherData.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import Foundation

struct WeatherData: Codable {
    let main: Main
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let sys: Sys
    let weather: [Weather]
    let coord: Coord
    let name: String
}

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
