//
//  Background.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 15/09/25.
//

import SwiftUI

class Background {
    func bgStyle(icon: String) -> String {
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
