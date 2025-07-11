//
//  AppViewModel.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//
import Foundation
import CoreLocation
import SwiftUI

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
    @Published var forecastData: ForecastData?
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
    
    func loadForecast(for coord: CLLocationCoordinate2D) {
        weatherService.fetchForecast(for: coord) { result in
            switch result {
            case .success(let dados):
                self.forecastData = dados
            case .failure(let erro):
                self.errorMessage = erro.localizedDescription
            }
        }
    }
}

struct Img {
    static let day = "day"
    static let dayCloud = "day-cloud"
    static let dayRain = "day-rain"
    static let daySnow = "day-snow"
    static let night = "night"
    static let nightCloud = "night-cloud"
    static let nightRain = "night-rain"
    static let nightSnow = "night-snow"
}

func backgroundImage(icon: String) -> String {
    switch icon {
    case "01d", "02d":
        return Img.day
    case "03d", "04d", "50d":
        return Img.dayCloud
    case "09d", "10d", "11d":
        return Img.dayRain
    case "01n", "02n":
        return Img.night
    case "03n", "04n", "50n":
        return Img.nightCloud
    case "09n", "10n", "11n":
        return Img.nightRain
    case "13d":
        return Img.daySnow
    case "13n":
        return Img.nightSnow
    default:
        return Img.day
    }
}

extension Image {
    func myIconStyle(_ icon: String) -> some View {
        Group {
            switch icon {
            case "01d":
                self.foregroundColor(Color(.colorSun))
            case "02d":
                self.foregroundStyle(.white, .colorSun)
            case "09d", "09n", "11d", "11n":
                self.foregroundStyle(.white, .colorBlue)
            case "10d":
                self.foregroundStyle(.white, .colorSun, .colorBlue)
            case "10n":
                self.foregroundStyle(.white, .white, .colorBlue)
            case "13d", "13n":
                self.foregroundColor(Color(.colorBlue))
            default:
                self.foregroundColor(.white)
            }
        }
    }
}

extension Image {
    func myColorTemp(_ temp: String) -> some View {
        Group {
            switch temp {
            case "low":
                self.foregroundStyle(.blue.opacity(0.6), .white)
            case "high":
                self.foregroundStyle(.red.opacity(0.6), .white)
            default:
                self.foregroundColor(.white)
            }
        }
    }
}

extension View {
    func myAnimationBounce() -> some View {
        self.modifier(MyBounceEffect())
    }
}

struct MyBounceEffect: ViewModifier {
    @State private var bounce = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(bounce ? 1.04 : 1.0)
            .offset(y: bounce ? -1 : 0)
            .animation(
                Animation.easeInOut(duration: 0.6)
                    .repeatForever(autoreverses: true),
                value: bounce
            )
            .onAppear {
                bounce = true
            }
    }
}

struct SymbolPorcentageView: View {
    var progress: Double
    
    var body: some View {
        let fillFraction = min(max(progress / 100, 0), 1)
        
        ZStack {
            Image(systemName: "cloud")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            
            Image(systemName: "cloud.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white.opacity(0.6))
                .mask(
                    GeometryReader { geo in
                        Rectangle()
                            .size(width: geo.size.width, height: geo.size.height * fillFraction)
                            .offset(y: geo.size.height * (1 - fillFraction))
                    }
                )
        }
        .frame(width: 100, height: 100)
    }
}

