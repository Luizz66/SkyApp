//
//  MainForecastView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct MainForecastView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let clima = weatherViewModel.weatherData {
                Text(clima.name)
                    .font(.itim(size: 35))
                    .padding(.bottom, 1)
                HStack {
                    VStack(alignment: .leading) {
                        Text(clima.formattedTemp.mainTemp)
                            .padding(.trailing, 15)
                        Text(clima.mainDescription)
                            .font(.itim(size: 21))
                            .opacity(0.6)
                    }
                    Image(systemName: clima.mySFSymbol)
                        .symbolStyle(clima.weather[0].icon)
                        .animationBounce()
                        .font(.system(size: 90))
                }
                .font(.itim(size: 85))
            } else if let erro = weatherViewModel.errorMessage {
                Text("❌ Erro: \(erro)")
                    .font(.itim(size: 16))
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weatherViewModel.loadWeather(for: coordinate)
        }
        .safeAreaPadding(.top, 85)
        .padding(.bottom, 50)
    }
}

#Preview {
    MainForecastView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .preferredColorScheme(.dark)
}
