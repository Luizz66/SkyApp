//
//  BackgroundImgView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct BackgroundView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var search: Search
    
    let bg = Background()
    
    var body: some View {
        VStack {
            if let clim = weatherViewModel.weatherData {
                Image(bg.bgStyle(icon: clim.weather[0].icon))
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                    .overlay(Color.black.opacity(0.4))
            } else {
                ZStack{
                    Image("loading")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .blur(radius: 85)
                        .overlay(
                            Color.black.opacity(0.75)
                        )
                    VStack(spacing: 20) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(2.6)
                    }
                }
            }
        }
        .onReceive(locationManager.coordinatePublisher(isSearch: search.isSearch).compactMap { $0 }) { coordinate in
            Task {
                await weatherViewModel.loadWeather(for: coordinate)
            }
        }
    }
}

#Preview {
    BackgroundView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .environmentObject(Search()) 
        .preferredColorScheme(.dark)
}
