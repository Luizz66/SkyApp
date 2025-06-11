//
//  Useful.swift
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

extension Font {
    static func itim(size: CGFloat) -> Font {
        .custom("Itim", size: size)
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

struct Bg {
    static let day: String = "day"
    static let dayRain: String = "day-rain"
    static let dayCloud: String = "day-cloud"
    static let night: String = "night"
    static let nightRain: String = "night-rain"
    static let nightCloud: String = "night-cloud"
}

func formatTemp(temp: Double) -> String {
    let formatted = String(format: "%.1f", temp).replacingOccurrences(of: ".", with: ",")
    
    if formatted.last == "0" {
        return String(format: "%.0f°", temp).replacingOccurrences(of: ".", with: ",")
    } else {
        return formatted + "°"
    }
}

func formatMaxTemp(temp: Double) -> String {
    let str = String(format: "%.0f", temp)
    let formatted = "Máx:. \(str)°"
    return formatted
}

func formatMinTemp(temp: Double) -> String {
    let str = String(format: "%.0f", temp)
    let formatted = "Mín:. \(str)°"
    return formatted
}

func formatWind(wind: Double) -> String {
    return String(format: "%.1f km/h", wind * 3.6).replacingOccurrences(of: ".", with: ",")
}

func formatPrecipitation (rain: Double) -> String {
    return String(format: "%.1f mm" , rain).replacingOccurrences(of: ".", with: ",")
}

func formatSys(from timestamp: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    formatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
    
    return formatter.string(from: date) + " h"
}
