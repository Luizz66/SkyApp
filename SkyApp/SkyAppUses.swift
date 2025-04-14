//
//  AppUses.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 11/04/25.
//
import SwiftUI

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
    func animationBounce() -> some View {
        self.modifier(BounceEffect())
    }
}

// Modificador customizado para o efeito de bounce
struct BounceEffect: ViewModifier {
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

struct Bg {
    static let day: String = "day"
    static let dayRain: String = "day-rain"
    static let dayCloud: String = "day-cloud"
    static let night: String = "night"
    static let nightRain: String = "night-rain"
    static let nightCloud: String = "night-cloud"
}

func formatTemp(temp: Double) -> String {
    return String(format: "%.0f°C", temp)
}

func formatWind(wind: Double) -> String {
    return String(format: "%.1f km/h", wind * 3.6).replacingOccurrences(of: ".", with: ",")
}

//del
func printWeatherData(_ data: WeatherData) {
    print(" --- DADOS DO CLIMA ---")
    print("Cidade: \(data.name)")
    print("Temperatura atual: \(data.main.temp)°C")
    print("Mínima: \(data.main.temp_min)°C")
    print("Máxima: \(data.main.temp_max)°C")
    print("Umidade: \(data.main.humidity)%")
    print("Vento: \(data.wind.speed) m/s")
    print("Latitude: \(data.coord.lat)")
    print("Longitude: \(data.coord.lon)")
    
    if let clima = data.weather.first {
        print("☁️ Clima: \(clima.main)")
        print("📝 Descrição: \(clima.description)")
    }
}
