//
//  BackgroundImgView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct BackgroundImgView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let clima = weatherViewModel.weatherData {
                Image(Style().backgroundStyle(icon: clima.weather[0].icon))
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                    .overlay(
                        clima.weather[0].icon.last == "d" ? Color.black.opacity(0.4) : Color.black.opacity(0.3)
                    )
            } else {
                LoadingScreenView()
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weatherViewModel.loadWeather(for: coordinate)
        }
    }
}

#Preview {
    BackgroundImgView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .preferredColorScheme(.dark)
}
