//
//  Style.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 15/09/25.
//

import SwiftUI

class Style {
    func backgroundStyle(icon: String) -> String {
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

    private struct Img {
        static let day = "day"
        static let dayCloud = "day-cloud"
        static let dayRain = "day-rain"
        static let daySnow = "day-snow"
        static let night = "night"
        static let nightCloud = "night-cloud"
        static let nightRain = "night-rain"
        static let nightSnow = "night-snow"
    }
}

extension Image {
    func symbolStyle(_ icon: String) -> some View {
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

extension Font {
    static func itim(size: CGFloat) -> Font {
        .custom("Itim", size: size)
    }
}
