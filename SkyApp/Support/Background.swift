//
//  Background.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 15/09/25.
//

import SwiftUI

class Background {
    static func img(icon: String) -> String {
        switch icon {
        case "01d", "02d":
            return ImgStrName.day
        case "03d", "04d", "50d":
            return ImgStrName.dayCloud
        case "09d", "10d", "11d":
            return ImgStrName.dayRain
        case "01n", "02n":
            return ImgStrName.night
        case "03n", "04n", "50n":
            return ImgStrName.nightCloud
        case "09n", "10n", "11n":
            return ImgStrName.nightRain
        case "13d":
            return ImgStrName.daySnow
        case "13n":
            return ImgStrName.nightSnow
        default:
            return ImgStrName.day
        }
    }

    private struct ImgStrName {
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
