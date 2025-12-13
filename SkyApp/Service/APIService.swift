//
//  APIService.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 25/06/25.
//

import Foundation
import CoreLocation

class APIService {
    private let token = apiKey
    private let baseURL = "https://api.openweathermap.org/data/2.5/"
    
    func fetchCurrentWeather(for coord: CLLocationCoordinate2D) async throws -> WeatherData {
        let urlString = "\(baseURL)weather?lat=\(coord.latitude)&lon=\(coord.longitude)&appid=\(token)&units=metric&lang=pt_br"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let weather = try JSONDecoder().decode(WeatherData.self, from: data)
        return weather
    }
    
    func fetchForecast(for coord: CLLocationCoordinate2D) async throws -> ForecastData {
        let urlString = "\(baseURL)forecast?lat=\(coord.latitude)&lon=\(coord.longitude)&appid=\(token)&units=metric&lang=pt_br"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let forecast = try JSONDecoder().decode(ForecastData.self, from: data)
        return forecast
    }
    
    //translate city
    func fetchGeocode(for city: String) async throws -> [GeocodingData] {
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=1&appid=\(token)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let geocoding = try JSONDecoder().decode([GeocodingData].self, from: data)
        return geocoding
    }
    
    private static var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let apiKey = dict["API_KEY"] as? String else {
            fatalError("API Key não encontrada")
        }
        return apiKey
    }
}

