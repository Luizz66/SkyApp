//
//  ContentView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 15/12/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var forecastViewModel: ForecastViewModel
    @EnvironmentObject var search: Search
    
    var erroMessage: String? {
        weatherViewModel.errorMessage ??
        forecastViewModel.errorMessage
    }
    
    var body: some View {
        Group {
            if let _ = weatherViewModel.weatherData,
               let _ = forecastViewModel.forecastData {
                
                RootView()
                
            } else if let erro = erroMessage {
                ZStack {
                    LoadingView()
                    ThreeDotsAnimationView()
                        .onAppear {
                            print("❌ \(erro.uppercased())")
                        }
                }
            } else {
                LoadingView()
            }
        }
        .preferredColorScheme(.dark)
        .onReceive(locationManager.coordinatePublisher(isSearch: search.isSearch).compactMap { $0 }) { coordinate in
            Task {
                await weatherViewModel.loadWeather(for: coordinate)
                await forecastViewModel.loadForecast(for: coordinate)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .environmentObject(ForecastViewModel())
        .environmentObject(Search())
}
