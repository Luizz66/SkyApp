//
//  ContentViewModel.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

// get localização atual
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var city: String = "Carregando..."
    @Published var state: String = "Carregando..."
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        fetchCityAndState(from: location)
    }
    
    private func fetchCityAndState(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    self.city = placemark.locality ?? "Cidade desconhecida"
                    self.state = placemark.administrativeArea ?? "Estado desconhecido"
                }
            }
        }
    }
}

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var errorMessage: String?

    private let weatherService = WeatherService()

    func loadWeather(for cidade: String) {
        weatherService.fetchWeather(for: cidade) { result in
            switch result {
            case .success(let dados):
                self.weatherData = dados
            case .failure(let erro):
                self.errorMessage = erro.localizedDescription
            }
        }
    }
}


class WeatherService {
    private let token = Secrets.apiKey
    
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(token)&units=metric&lang=pt"
        
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
                let decoder = JSONDecoder()
                let weather = try decoder.decode(WeatherData.self, from: data)
                
                printWeatherData(weather)
                
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
