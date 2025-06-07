//
//  SkyAppView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import SwiftUI

struct SkyAppView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject var weatherViewModel = WeatherViewModel()

    var body: some View {
        ZStack {
            ImgBackgroundView()
            VStack {
                MainForecastView()
                    .respectSafeAre()
                ScrollView(.vertical, showsIndicators: false) {
                    TemperatureRangeView()
                    DaysForecastView()
                    ForecastDetails()
                }
            }
        }
        .environmentObject(locationManager)
        .environmentObject(weatherViewModel)
    }
}

struct MainForecastView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let clima = weatherViewModel.weatherData {
                Text(clima.name)
                    .font(.custom("Itim", size: 35))
                    .padding(.bottom, 1)
                HStack {
                    VStack(alignment: .leading) {
                        Text(formatTemp(temp: clima.main.temp))
                            .padding(.trailing, 15)
                        Text(clima.weather.first?.description ?? "...")
                            .font(.system(size: 26))
                            .opacity(0.6)
                    }
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 95))
                        .foregroundColor(.yellow)
                        .myAnimationBounce()
                }
                .font(.custom("Itim", size: 80))
            } else if let erro = weatherViewModel.errorMessage {
                Text("Erro: \(erro)")
            } else {
                Text("Carregando...")
                    .font(.custom("Itim", size: 35))
                    .padding(.bottom, 1)
                    .foregroundColor(.white)
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weatherViewModel.loadWeather(for: coordinate)
        }
        .foregroundColor(.white)
        .padding(.top, 70)
        .padding(.bottom, 40)
    }
}

struct TemperatureRangeView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let clima = weatherViewModel.weatherData {
                HStack {
                    Image(systemName: "thermometer.low")
                    Text(formatMinTemp(temp: clima.main.temp_min))
                        .padding(.trailing, 30)
                    Image(systemName: "thermometer.high")
                    Text(formatMaxTemp(temp: clima.main.temp_max))
                }
                .foregroundColor(.white)
                .font(.custom("Itim", size: 23))
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(20)
                .padding(.bottom, 35)
            } else if let erro = weatherViewModel.errorMessage {
                Text("Erro: \(erro)")
            } else {
                Text("Carregando...")
                    .font(.custom("Itim", size: 35))
                    .padding(.bottom, 1)
                    .foregroundColor(.white)
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weatherViewModel.loadWeather(for: coordinate)
        }
    }
}


struct DaysForecastView: View {
    var body: some View {
        HStack {
            Image(systemName: "calendar")
            Text("PREVISÃO PARA 5 DIAS")
        }
        .font(.custom("Itim", size: 20))
        .opacity(0.6)
        .padding(.bottom, 10)
        .foregroundColor(.white)
        VStack {
                ForEach(0...4, id: \.self) { item in
                    HStack {
                        Text("TER")
                        Spacer()
                        Image(systemName: "cloud.drizzle.fill")
                            .myAnimationBounce()
                        Spacer()
                        Text("mín: 25°")
                            .padding(.trailing, 10)
                        Text("máx: 35°")
                    }
                    .font(.custom("Itim", size: 20))
                    .foregroundColor(.white)
                    .padding(.bottom, 17)
                }
        }
        .padding([.trailing, .leading, .bottom],15)
    }
}

struct ForecastDetails: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "humidity.fill")
                        Text("UMIDADE")
                    }
                    Text("60%")
                }
                .background(Color.red)
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "humidity.fill")
                        Text("VENTO")
                    }
                    Text("60%")
                }
                .background(Color.red)
            }
            VStack {
                Text("SENSAÇÃO")
                Text("60%")
            }
            .background(Color.red)
        }
    }
}

struct ImgBackgroundView: View {
    var body: some View {
        ZStack {
            Image(Bg.day)
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.4)
                )
        }
    }
}

#Preview {
    SkyAppView()
}
