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
    
    let style = Style()
    
    var body: some View {
        VStack {
            if let clima = weatherViewModel.weatherData {
                Image(style.backgroundStyle(icon: clima.weather[0].icon))
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                    .overlay(Color.black.opacity(0.4))
            } else {
                LoadScreenView()
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
