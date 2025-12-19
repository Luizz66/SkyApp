//
//  ForecastData.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 15/09/25.
//

import Foundation

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
