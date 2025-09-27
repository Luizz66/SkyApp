//
//  ContentView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var weatherViewModel = WeatherViewModel()
    @StateObject var forecastViewModel = ForecastViewModel()
    
    var body: some View {
        ZStack {
            BackgroundImgView()
            VStack {
                MainForecastView()
                ScrollView(.vertical, showsIndicators: false) {
                    RangeForecastView()
                    WeekForecastView()
                    DetailsForecastView()
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 30)
                .cornerRadius(25)
            }
            .preferredColorScheme(.dark)
        }
        .environmentObject(locationManager)
        .environmentObject(weatherViewModel)
        .environmentObject(forecastViewModel)
    }
}

#Preview {
    ContentView()
}
