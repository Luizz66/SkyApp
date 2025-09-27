//
//  DetailsForecastView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct DetailsForecastView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let clima = weatherViewModel.weatherData {
                HStack {
                    HumidityAndWindView(weatherData: clima)
                    SensationView(weatherData: clima)
                }
                HStack {
                    PrecipitationView(weatherData: clima)
                    Sunriseview(weatherData: clima)
                }
                CloudsView(weatherData: clima)
            } else if let erro = weatherViewModel.errorMessage {
                Text("❌ Erro: \(erro)")
                    .font(.itim(size: 16))
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weatherViewModel.loadWeather(for: coordinate)
        }
    }
}

struct HumidityAndWindView: View {
    var weatherData: WeatherData
    
    var body: some View {
        VStack {
            Group {
                VStack (alignment: .leading) {
                    HStack {
                        Image(systemName: "humidity.fill")
                        Text("UMIDADE")
                    }
                    .opacity(0.6)
                    .padding(.bottom, 0.1)
                    Text("\(weatherData.main.humidity)%")
                        .font(.itim(size: 30))
                }
                VStack (alignment: .leading) {
                    HStack {
                        Image(systemName: "wind")
                        Text("VENTO")
                    }
                    .opacity(0.6)
                    .padding(.bottom, 0.1)
                    Text(weatherData.formattedWind)
                        .font(.itim(size: 30))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(8)
            .font(.itim(size: 15))
            .background(.white.opacity(0.1))
            .cornerRadius(20)
        }
    }
}

struct SensationView: View {
    var weatherData: WeatherData
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image(systemName: "thermometer.medium")
                Text("SENSAÇÃO")
            }
            .opacity(0.6)
            .padding(.bottom, 0.1)
            Text(weatherData.formattedTemp.feelsLike)
                .font(.itim(size: 30))
            Spacer()
            Text(weatherData.sensationDescription)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(8)
        .font(.itim(size: 15))
        .background(.white.opacity(0.1))
        .cornerRadius(20)
    }
}

struct PrecipitationView: View {
    var weatherData: WeatherData
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image(systemName: "drop.fill")
                Text("PRECIPITAÇÃO")
            }
            .opacity(0.6)
            .padding(.bottom, 0.1)
            Text(weatherData.formattedPrecipitation)                            .font(.itim(size: 30))
                .padding(.bottom, 50)
            Spacer()
            Text("nas últimas 1h.")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(8)
        .font(.itim(size: 15))
        .background(.white.opacity(0.1))
        .cornerRadius(20)
    }
}

struct Sunriseview: View {
    var weatherData: WeatherData
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image(systemName: "sunrise.fill")
                Text("NASCER DO SOL")
            }
            .opacity(0.6)
            .padding(.bottom, 0.1)
            Text(weatherData.formattedSys.sunrise)
                .font(.itim(size: 30))
            Spacer()
            Text("Pôr do sol: \(weatherData.formattedSys.sunset)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(8)
        .font(.itim(size: 15))
        .background(.white.opacity(0.1))
        .cornerRadius(20)
    }
}

struct CloudsView: View {
    var weatherData: WeatherData
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image(systemName: "cloud.fill")
                Text("NUVENS")
            }
            .opacity(0.6)
            .padding(.bottom, 0.1)
            HStack {
                Text("\(weatherData.clouds.all)% do céu.")
                    .font(.itim(size: 30))
                Spacer()
                SymbolPorcentageView(progress: Double(weatherData.clouds.all))
                    .font(.itim(size: 65))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(10)
        .font(.itim(size: 15))
        .background(.white.opacity(0.1))
        .cornerRadius(20)
    }
}

#Preview {
    DetailsForecastView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .preferredColorScheme(.dark)
}
