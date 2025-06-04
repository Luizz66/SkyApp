//
//  ContentViewModel.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import Foundation
import CoreLocation

//get localização atual
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var coordinate: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.coordinate = location.coordinate
        }
    }
}

//loadWeather
class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var errorMessage: String?

    private let weatherService = WeatherService()

    func loadWeather(for coord: CLLocationCoordinate2D) {
        weatherService.fetchWeather(for: coord) { result in
            switch result {
            case .success(let dados):
                self.weatherData = dados
            case .failure(let erro):
                self.errorMessage = erro.localizedDescription
            }
        }
    }
}

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
                
                printWeatherData(weather)//del
                
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

//del
func printWeatherData(_ data: WeatherData) {
    print(" --- DADOS DO CLIMA ---")
    print("Cidade: \(data.name)")
    print("Temperatura atual: \(data.main.temp)°C")
    print("Sensação Térmica: \(data.main.feels_like)°C")
    print("Mínima: \(data.main.temp_min)°C")
    print("Máxima: \(data.main.temp_max)°C")
    print("Umidade: \(data.main.humidity)% do céu")
    print("Vento: \(data.wind.speed) m/s")
    print("Chuva: \(data.rain?.one ?? 0) mm nas últimas 1h")
    print("Nuvems: \(data.clouds.all)%")
    if let clima = data.weather.first {
        print("Clima: \(clima.main)")
        print("Icon: \(clima.icon)")
    }
    print("Latitude: \(data.coord.lat)")
    print("Longitude: \(data.coord.lon)")
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
