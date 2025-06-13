//
//  Useful.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 11/04/25.
//
import SwiftUI

struct Bg {
    static let day: String = "day"
    static let dayRain: String = "day-rain"
    static let dayCloud: String = "day-cloud"
    static let night: String = "night"
    static let nightRain: String = "night-rain"
    static let nightCloud: String = "night-cloud"
}

extension Font {
    static func itim(size: CGFloat) -> Font {
        .custom("Itim", size: size)
    }
}

func formatTemp(temp: Double) -> String {
    let formatted = String(format: "%.1f°", temp).replacingOccurrences(of: ".", with: ",")
    
    if formatted.last == "0" {
        let intTemp = Int(temp)
        return "\(intTemp)°"
    } else {
        return formatted
    }
}

func formatRangeTemp(txt: String, temp: Double) -> String {
    let str = String(format: "%.0f", temp)
    let formatted = "\(txt).: \(str)°"
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

func sensationDescription(temp: Double, feelsLike: Double) -> String {
    let intTemp = Int(temp)
    let intFeelsLike = Int(feelsLike)

    if intFeelsLike < intTemp {
        return "A sensação térmica está mais baixa do que a temperatura real."
    }
    else if intFeelsLike > intTemp {
        return "A sensação térmica está mais alta do que a temperatura real."
    }
    else {
        return "Similar à temperatura real."
    }
}

func mainIcon(icon: String) -> String {
    return iconsSF[icon] ?? "circle.badge.questionmark.fill"
}

let iconsSF: [String: String] = [
    "01d": "sun.max.fill",
    "01n": "moon.stars.fill",
    "02d": "cloud.sun.fill",
    "02n": "cloud.moon.fill",
    "03d": "cloud.fill",
    "03n": "cloud.fill",
    "04d": "smoke.fill",
    "04n": "smoke.fill",
    "09d": "cloud.drizzle.fill",
    "09n": "cloud.drizzle.fill",
    "10d": "cloud.sun.rain.fill",
    "10n": "cloud.moon.rain.fill",
    "11d": "cloud.bolt.rain.fill",
    "11n": "cloud.bolt.rain.fill",
    "13d": "snowflake",
    "13n": "snowflake",
    "50d": "cloud.fog.fill",
    "50n": "cloud.fog.fill"
]


func mainDescription(id: Int) -> String {
    return descriptionMap[id] ?? "Condição desconhecida"
}

let descriptionMap: [Int: String] = [
    200: "Trovoada com chuva fraca",
    201: "Trovoada com chuva",
    202: "Trovoada com chuva forte",
    210: "Trovoada fraca",
    211: "Trovoada",
    212: "Trovoada forte",
    221: "Trovoada irregular",
    230: "Trovoada com garoa fraca",
    231: "Trovoada com garoa",
    232: "Trovoada com garoa forte",
    300: "Garoa de intensidade fraca",
    301: "Garoa",
    302: "Garoa de intensidade forte",
    310: "Chuva com garoa de intensidade fraca",
    311: "Chuva com garoa",
    312: "Chuva com garoa de intensidade forte",
    313: "Pancadas de chuva com garoa",
    314: "Pancadas fortes de chuva com garoa",
    321: "Pancada de garoa",
    500: "Chuva fraca",
    501: "Chuva moderada",
    502: "Chuva de intensidade forte",
    503: "Chuva muito forte",
    504: "Chuva extrema",
    511: "Chuva congelante",
    520: "Pancada de chuva fraca",
    521: "Pancada de chuva",
    522: "Pancada de chuva forte",
    531: "Pancadas irregulares de chuva",
    600: "Neve fraca",
    601: "Neve",
    602: "Neve forte",
    611: "Granizo",
    612: "Pancada de granizo fraco",
    613: "Pancada de granizo",
    615: "Chuva fraca com neve",
    616: "Chuva com neve",
    620: "Pancada de neve fraca",
    621: "Pancada de neve",
    622: "Pancada de neve forte",
    701: "Névoa",
    711: "Fumaça",
    721: "Neblina seca",
    731: "Redemoinhos de areia/poeira",
    741: "Nevoeiro",
    751: "Areia",
    761: "Poeira",
    762: "Cinzas vulcânicas",
    771: "Rajadas de vento",
    781: "Tornado",
    800: "Céu limpo",
    801: "Poucas nuvens: 11-25%",
    802: "Nuvens dispersas: 25-50%",
    803: "Nuvens quebradas: 51-84%",
    804: "Nuvens encobertas: 85-100%"
]
