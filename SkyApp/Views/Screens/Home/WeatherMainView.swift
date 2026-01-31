//
//  WeatherMainView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct WeatherMainView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var forecastViewModel: ForecastViewModel
    
    @StateObject var geocodingViewModel = GeocodingViewModel()
    
    var body: some View {
        VStack {
            if let clim = weatherViewModel.weatherData {
                Text(geocodingViewModel.cityTranslate ?? clim.name)
                    .font(.comicNeue(size: 35, weight: .regular))
                    .padding(.bottom, 10)
                    .padding(.top, 30)
                    .shadow(color: .black, radius: 0.8)
                VStack {
                    HStack {
                        Text(WeatherFormat.temp(clim.main.temp))
                            .font(.comicNeue(size: 90, weight: .light))
                            .padding(.trailing, 10)
                        Image(systemName: Symbol.mySFSymbol(icon: clim.weather[0].icon))
                            .symbolStyle(clim.weather[0].icon)
                            .myAnimation()
                            .font(.system(size: 88))
                    }
                    .shadow(color: .black, radius: 0.8)
                    .padding(.bottom, -5)
                    
                    Text(WeatherFormat.mainDescription(clim.weather.first?.description))
                        .font(.comicNeue(size: 22))
                        .opacity(0.7)
                }
                .padding(.bottom, 10)
                
                rangeForecastView(forecastViewModel)
                
            }
        }
        .safeAreaPadding(.top, 70)
        .onReceive(weatherViewModel.$weatherData) { clim in
            Task {
               await geocodingViewModel.loadGeocode(for: clim?.name.capitalized ?? "")
            }
        }
    }
}

func rangeForecastView(_ forecastViewModel: ForecastViewModel) -> some View {
    VStack {
        if let todayTemp = forecastViewModel.todayMinMaxTemp {
            HStack {
                Label { 
                    Text(todayTemp.min)
                        .shadow(color: .black, radius: 0.8)
                } icon: { 
                    Image(systemName: "thermometer.low")
                        .font(.system(size: 21))
                        .foregroundStyle(.blue.opacity(0.6), .white)
                        .opacity(0.8)
                }
                .padding(.trailing, 15)
                
                Label { 
                    Text(todayTemp.max)
                        .shadow(color: .black, radius: 0.8)
                } icon: { 
                    Image(systemName: "thermometer.high")
                        .font(.system(size: 21))
                        .foregroundStyle(.red.opacity(0.6), .white)
                        .opacity(0.8)
                }
            }
            .font(.comicNeue(size: 23))
            .padding(.bottom, 15)
        }
    }
}

#Preview {
    WeatherMainView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .environmentObject(ForecastViewModel())
        .environmentObject(Search())
        .preferredColorScheme(.dark)
}
