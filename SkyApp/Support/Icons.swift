//
//  Icons.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 15/09/25.
//

import Foundation
import SwiftUI

class Icons {
    private let SF_Symbols: [String: String] = [
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
    
    static func myIcon(_ icon: String) -> String {
        return Icons().SF_Symbols[icon] ?? "circle.badge.questionmark.fill"
    }
}

extension Image {
    func iconStyle(_ icon: String) -> some View {
        Group {
            switch icon {
            case "01d":
                self.foregroundColor(Color(.iconColorSun))
            case "02d":
                self.foregroundStyle(.white, .iconColorSun)
            case "09d", "09n", "11d", "11n":
                self.foregroundStyle(.white, .iconColorBlue)
            case "10d":
                self.foregroundStyle(.white, .iconColorSun, .iconColorBlue)
            case "10n":
                self.foregroundStyle(.white, .white, .iconColorBlue)
            case "13d", "13n":
                self.foregroundColor(Color(.iconColorBlue))
            default:
                self.foregroundColor(.white)
            }
        }
    }
}
