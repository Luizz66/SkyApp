//
//  MainForecastView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct MainWeatherView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var forecastViewModel: ForecastViewModel
    
    var body: some View {
        VStack {
            if let clima = weatherViewModel.weatherData {
                Text(clima.name)
                    .font(.itim(size: 35))
                    .padding(.bottom, 10)
                    .shadow(color: .black, radius: 1)
                VStack {
                    HStack {
                        Text(clima.formattedTemp.mainTemp)
                            .padding(.trailing, 15)
                        Image(systemName: clima.mySFSymbol)
                            .symbolStyle(clima.weather[0].icon)
                            .animationBounce()
                            .font(.system(size: 90))
                    }
                    .shadow(color: .black, radius: 1)
                    
                    Text(clima.mainDescription)
                        .font(.itim(size: 22))
                        .opacity(0.7)
                }
                .font(.itim(size: 85))
                .padding(.bottom, 10)
                
                RangeForecastView(locationManager, forecastViewModel)
                
            } else if let erro = weatherViewModel.errorMessage {
                GeometryReader { geo in
                    VStack {
                        Text("❌ \(erro.uppercased())")
                            .font(.itim(size: 16))
                            .padding(.bottom, 50)
                    }                    
                    .frame(width: geo.size.width / 1.3, height: geo.size.height)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .safeAreaPadding(.top, 70)
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weatherViewModel.loadWeather(for: coordinate)
        }
    }
}

func RangeForecastView(_ locationManager: LocationManager,_ forecastViewModel: ForecastViewModel) -> some View {
    VStack {
        if let todayTemp = forecastViewModel.todayMinMaxTemp {
            HStack {
                Label { 
                    Text(todayTemp.min)
                        .shadow(color: .black, radius: 1)
                } icon: { 
                    Image(systemName: "thermometer.low")
                        .foregroundStyle(.blue, .white)
                        .opacity(0.8)
                }
                .padding(.trailing, 30)
                
                Label { 
                    Text(todayTemp.max)
                        .shadow(color: .black, radius: 1)
                } icon: { 
                    Image(systemName: "thermometer.high")
                        .foregroundStyle(.red, .white)
                        .opacity(0.8)
                }
            }
            .font(.itim(size: 23))
            .padding(.bottom, 15)
        }
    }
    .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
        forecastViewModel.loadForecast(for: coordinate)
    }
}

#Preview {
    MainWeatherView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .preferredColorScheme(.dark)
}
