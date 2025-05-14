//
//  ContentView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject var weatherViewModel = WeatherViewModel()

    var body: some View {
        ZStack {
            ImgBackgroundView()
            VStack {
                MainForecastView()
                    .respectSafeAre()
                AirHumidityView()
                HourlyForecastView()
                DaysForecastView()
            }
        }
        .environmentObject(locationManager)
        .environmentObject(weatherViewModel)
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
                    Text(formatTemp(temp: clima.main.temp))
                        .padding(.trailing, 15)
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.yellow)
                        .animationBounce()
                }
                .font(.custom("Itim", size: 80))
            } else if let erro = weatherViewModel.errorMessage {
                Text("Erro: \(erro)")
            } else {
                Text("Carregando...")
                    .font(.custom("Itim", size: 35))
                    .padding(.bottom, 1)
            }
        }
        .onReceive(locationManager.$city.dropFirst()) { cidade in
            weatherViewModel.loadWeather(for: cidade)
        }
        .foregroundColor(.white)
        .padding(.top, 70)
        .padding(.bottom, 25)
    }
}

struct AirHumidityView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let clima = weatherViewModel.weatherData {
                HStack {
                    Text("Umidade")
                    Spacer()
                    Text("\(clima.main.humidity)%")
                }
                HStack {
                    Text("Vento")
                    Spacer()
                    Text(formatWind(wind: clima.wind.speed))
                }
            } else if let erro = weatherViewModel.errorMessage {
                Text("Erro: \(erro)")
            } else {
                Text("Carregando...")
                    .font(.custom("Itim", size: 35))
                    .padding(.bottom, 1)
            }
        }
        .onReceive(locationManager.$city.dropFirst()) { cidade in
            weatherViewModel.loadWeather(for: cidade)
        }
        .font(.custom("Itim", size: 19))
        .foregroundColor(.white)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .opacity(0.1)
        )
        .padding([.trailing, .leading], 70)
        .padding(.bottom, 30)
    }
}

struct HourlyForecastView: View {
    var body: some View {
        Text("PREVISÃO POR HORA")
            .font(.custom("Itim", size: 20))
            .foregroundColor(.white)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0...23, id: \.self) { index in
                    VStack {
                        Text("13:00")
                            .font(.custom("Itim", size: 19))
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.yellow)
                            .padding([.top, .bottom], 0.1)
                            .animationBounce()
                        Text("25°C")
                            .font(.custom("Itim", size: 22))
                        
                    }
                    .padding([.top, .bottom], 5)
                    .padding([.trailing, .leading], 17)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white).opacity(0.1)
                    )
                }
            }
        }
        .padding([.leading, .trailing], 15)
        .padding(.bottom, 30)
    }
}

struct DaysForecastView: View {
    var body: some View {
        Text("PRÓXIMOS DIAS")
            .font(.custom("Itim", size: 20))
            .foregroundColor(.white)
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(0...6, id: \.self) { index in
                        HStack {
                            Text("TER")
                            Spacer()
                            Image(systemName: "cloud.drizzle.fill")
                            Spacer()
                            Text("mín: 25°C")
                                .padding(.trailing, 10)
                            Text("máx: 35°C")
                        }
                        .font(.custom("Itim", size: 20))
                        .foregroundColor(.white)
                        .padding(.bottom, 17)
                    }
                }
            }
        }
        .padding([.trailing, .leading, .bottom],15)
    }
}

#Preview {
    ContentView()
}
