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
                MainWeatherView()
                ScrollView(.vertical, showsIndicators: false) {
                    WeekForecastView()
                    DetailsWeatherView()
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 30)
                .mask(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0.0),
                            .init(color: .black, location: 0.06),
                            .init(color: .black, location: 0.90),
                            .init(color: .black.opacity(0.1), location: 0.95),
                            .init(color: .clear, location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
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
