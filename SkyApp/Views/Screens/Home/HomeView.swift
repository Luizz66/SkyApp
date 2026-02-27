//
//  HomeView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var forecastViewModel: ForecastViewModel
    
    var erroMessage: String? {
        weatherViewModel.errorMessage ??
        forecastViewModel.errorMessage
    }
    
    var body: some View {
            ZStack {
                if let clim = weatherViewModel.weatherData,
                   let _ = forecastViewModel.forecastData {
                    BackgroundView(weatherIcon: clim.weather[0].icon)
                } else {
                    LoadingBgView()
                }
                VStack {
                    if let _ = weatherViewModel.weatherData,
                       let _ = forecastViewModel.forecastData {
                        WeatherMainView()
                        ScrollView(.vertical, showsIndicators: false) {
                            WeekForecastView()
                            DetailsWeatherView()
                        }
                        .padding(.horizontal, 15)
                        .padding(.bottom, 30)
                        .verticalFadeMask()
                    } else if let erro = erroMessage {
                        strEmptyMainView()
                        ScrollView(.vertical, showsIndicators: false) {
                            ErrorMsgView()
                                .onAppear {
                                    print("❌ \(erro.uppercased())")
                                }
                        }
                        .padding(.horizontal, 15)
                        .padding(.bottom, 30)
                        .verticalFadeMask()
                    } else {
                        strEmptyMainView()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.3)
                        Spacer()
                    }
                }
        }
    }
    
    private func strEmptyMainView() -> some View {
        Text("--")
            .font(.comicNeue(size: 95, weight: .light))
            .padding(.top, 70)
    }
}


#Preview {
    HomeView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .environmentObject(ForecastViewModel())
        .environmentObject(Search())
        .preferredColorScheme(.dark)
}
