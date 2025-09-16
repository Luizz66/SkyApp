//
//  Legend.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 15/09/25.
//

import Foundation

class Legend {
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
        801: "Poucas nuvens",
        802: "Nuvens dispersas",
        803: "Nuvens quebradas",
        804: "Nuvens encobertas"
    ]
    
    let SFSymbols: [String: String] = [
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
}
