//
//  Model.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//
import Foundation
import SwiftUICore

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
    
    let main: Main
    let wind: Wind
    let weather: [Weather]
    let name: String
}

struct Bg {
    static let daySum: String = "dia-sol"
    static let dayRain: String = "dia-chuva"
    static let dayCloud: String = "dia-nublado"
    static let nightMoon: String = "noite-lua"
    static let nightRain: String = "noite-chuva"
    static let nightCloud: String = "noite-nublada"
}


func printWeatherData(_ data: WeatherData) {
    print(" --- DADOS DO CLIMA ---")
    print("Cidade: \(data.name)")
    print("Temperatura atual: \(data.main.temp)°C")
    print("Mínima: \(data.main.temp_min)°C")
    print("Máxima: \(data.main.temp_max)°C")
    print("Umidade: \(data.main.humidity)%")
    print("Vento: \(data.wind.speed) m/s")
    
    if let clima = data.weather.first {
        print("☁️ Clima: \(clima.main)")
        print("📝 Descrição: \(clima.description)")
    }
}
