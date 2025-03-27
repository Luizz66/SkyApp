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

//get data openweather
func fetchWeather(city: String) {
    let token = Secrets.apiKey
    let apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(token)&units=metric&lang=pt"

    guard let url = URL(string: apiUrl) else {
        print("❌ URL inválida")
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("❌ Erro na requisição: \(error.localizedDescription)")
            return
        }

        guard let data = data else {
            print("❌ Dados vazios")
            return
        }

        formatPrintJSON(data)
        
    }.resume()
}

//format json
func formatPrintJSON(_ jsonData: Data) {
    if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
       let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
       let prettyString = String(data: prettyData, encoding: .utf8) {
        let _: () = JsonDecoder(jsonString: prettyString)
    } else {
        print("❌ Erro ao formatar JSON")
    }
}

func JsonDecoder(jsonString: String) {
    if let jsonData = jsonString.data(using: .utf8) { // jsonString deve conter o JSON recebido
        do {
            let decoder = JSONDecoder()
            let weather = try decoder.decode(WeatherData.self, from: jsonData)
            
            print("Cidade: \(weather.name)")
            print("Temperatura: \(weather.main.temp)°C")
            print("Temperatura Miníma: \(weather.main.temp_min)")
            print("Temperatura Máxima: \(weather.main.temp_max)")
            print("Umidade: \(weather.main.humidity)%")
            print("Velocidade do vento: \(weather.wind.speed)m/s")
            print("Principal: \(weather.weather[0].main)")
            print("Descrição: \(weather.weather[0].description)")
        } catch {
            print("Erro ao decodificar JSON: \(error)")
        }
    }
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

struct Bg {
    static let daySum: String = "dia-sol"
    static let dayRain: String = "dia-chuva"
    static let dayCloud: String = "dia-nublado"
    static let nightMoon: String = "noite-lua"
    static let nightRain: String = "noite-chuva"
    static let nightCloud: String = "noite-nublada"
}
