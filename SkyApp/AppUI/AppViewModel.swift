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
    static let night = "night"
    static let nightCloud = "night-cloud"
    static let nightRain = "night-rain"
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
        //tratar o 13d e 13n (neve)
    default:
        return Img.day
    }
}

extension View {
    func respectSafeAre() -> some View {
        self.safeAreaInset(edge: .top) {
            GeometryReader { geometry in
                Color.clear
                    .frame(height: geometry.safeAreaInsets.top )
            }
            .frame(height: 0)
        }
    }
}

// Extensão para adicionar a animação de bounce
extension View {
    func myAnimationBounce() -> some View {
        self.modifier(MyBounceEffect())
    }
}

// Modificador customizado para o efeito de bounce
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

struct LoadingScreenView: View {
    var body: some View {
        ZStack {
            Image("loading")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.2)
                )
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
    }
}

extension Image {
    func myIconStyle(_ icon: String) -> some View {
        Group {
            switch icon {
            case "01d":
                self.foregroundColor(Color(.colorSun))
            case "02d":
                self.foregroundStyle(.gray, .colorSun)
            case "09d", "09n", "11d", "11n":
                self.foregroundStyle(.gray, .blue)
            case "10d":
                self.foregroundStyle(.gray, .colorSun, .blue)
            case "10n":
                self.foregroundStyle(.gray, .white, .blue)
            case "13d", "13n":
                self.foregroundColor(Color(.colorSnow))
            case "50d", "50n":
                self.foregroundColor(Color(.gray)).opacity(0.4)
            default:
                self.foregroundColor(.white)
            }
        }
    }
}
