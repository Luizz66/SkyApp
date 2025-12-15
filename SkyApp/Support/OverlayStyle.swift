//
//  OverlayStyle.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 13/12/25.
//

import SwiftUI

extension Color {
    static func overlayStyle(icon: String) -> Color {
        switch icon {
        case "01d", "02d":
            return Color(.colorDay.mix(with: .black, by: 0.20))
        case "03d", "04d", "50d":
            return Color(.colorDayCloud.mix(with: .black, by: 0.23))
        case "09d", "10d", "11d":
            return Color(.colorDayRain.mix(with: .black, by: 0.2))
        case "01n", "02n":
            return Color(.colorNight.mix(with: .black, by: 0.3))
        case "03n", "04n", "50n":
            return Color(.colorNightCloud.mix(with: .black, by: 0.3))
        case "09n", "10n", "11n":
            return Color(.colorNightRain.mix(with: .white, by: 0.04))
        case "13d":
            return Color(.colorDaySnow.mix(with: .black, by: 0.12))
        case "13n":
            return Color(.colorNightSnow.mix(with: .black, by: 0.3))
        default:
            return Color(.colorDay.mix(with: .black, by: 0.20))
        }
    }
}
