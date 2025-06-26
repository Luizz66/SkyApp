//
//  Services.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 25/06/25.
//
import Foundation
import CoreLocation

//call api
class WeatherService {
    private let token = Secrets.apiKey
    
    func fetchWeather(for coord: CLLocationCoordinate2D, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coord.latitude)&lon=\(coord.longitude)&appid=\(token)&units=metric&lang=p"
        
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }
        
        //requisição
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Sem dados", code: -1)))
                }
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(weather))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchForecast(for coord: CLLocationCoordinate2D, completion: @escaping (Result<ForecastData, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(coord.latitude)&lon=\(coord.longitude)&appid=\(token)&units=metric&lang=pt"
        
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Sem dados", code: -1)))
                }
                return
            }
            
            do {
                let forecast = try JSONDecoder().decode(ForecastData.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(forecast))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

