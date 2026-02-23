//
//  SkyAppApp.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import SwiftUI

@main
struct SkyApp: App {
    @StateObject var locationManager = LocationManager()
    @StateObject var weatherViewModel = WeatherViewModel()
    @StateObject var forecastViewModel = ForecastViewModel()
    @StateObject var search = Search()
    
    var body: some Scene {
        WindowGroup {
            ContentTabView()
                .environmentObject(locationManager)
                .environmentObject(weatherViewModel)
                .environmentObject(forecastViewModel)
                .environmentObject(search)
                .preferredColorScheme(.dark)
        }
    }
}
