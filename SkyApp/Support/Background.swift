//
//  Background.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 15/09/25.
//

import SwiftUI

class Background {
    static func style(icon: String) -> String {
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
        static let day = "dayBG"
        static let dayCloud = "dayCloudBG"
        static let dayRain = "dayRainBG"
        static let daySnow = "daySnowBG"
        static let night = "nightBG"
        static let nightCloud = "nightCloudBG"
        static let nightRain = "nightRainBG"
        static let nightSnow = "nightSnowBG"
    }
}
