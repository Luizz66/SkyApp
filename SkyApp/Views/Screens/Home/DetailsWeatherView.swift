//
//  DetailsWeatherView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct DetailsWeatherView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let clim = weatherViewModel.weatherData {
                HStack {
                    humidityAndWindView(weatherData: clim)
                    sensationView(weatherData: clim)
                }
                HStack {
                    precipitationView(weatherData: clim)
                    sunriseView(weatherData: clim)
                }
                cloudsView(weatherData: clim)
            }
        }
    }
}

func humidityAndWindView(weatherData: WeatherData) -> some View {
    VStack {
        Group {
            VStack (alignment: .leading) {
                HStack {
                    Image(systemName: "humidity.fill")
                    Text("UMIDADE")
                }
                .opacity(0.7)
                .padding(.bottom, 20)
                Text("\(weatherData.main.humidity)%")
                    .font(.myFont(size: 30))
            }
            
            VStack (alignment: .leading) {
                HStack {
                    Image(systemName: "wind")
                    Text("VENTO")
                }
                .opacity(0.7)
                .padding(.bottom, 20)
                Text(WeatherFormat.wind(weatherData.wind.speed))
                    .font(.myFont(size: 30))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(15)
        .font(.myFont(size: 16))
        .myOverlay(weather: weatherData)
        .padding(.bottom, 3)
    }
    .padding(.trailing, 3)
}

func sensationView(weatherData: WeatherData) -> some View {
    VStack (alignment: .leading) {
        HStack {
            Image(systemName: "thermometer.medium")
            Text("SENSAÇÃO")
        }
        .opacity(0.7)
        .padding(.bottom, 20)
        Text(WeatherFormat.temp(weatherData.main.feels_like))
            .font(.myFont(size: 30))
        Spacer()
        Text(WeatherFormat.sensationDescription(weatherData.main.temp, weatherData.main.feels_like))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .padding(15)
    .font(.myFont(size: 16))
    .myOverlay(weather: weatherData)
    .padding([.bottom, .leading], 3)
}

func precipitationView(weatherData: WeatherData) -> some View {
    VStack (alignment: .leading) {
        HStack {
            Image(systemName: "drop.fill")
            Text("PRECIPITAÇÃO")
        }
        .opacity(0.7)
        .padding(.bottom, 40)
        Text(WeatherFormat.precipatation(weatherData.rain?.oneHour)) 
            .font(.myFont(size: 30))
            .padding(.bottom, 50)
        Spacer()
        Text("nas últimas 1h.")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .padding(15)
    .font(.myFont(size: 16))
    .myOverlay(weather: weatherData)
    .padding([.bottom, .trailing], 3)
}

func sunriseView(weatherData: WeatherData) -> some View {
    VStack (alignment: .leading) {
        HStack {
            Image(systemName: "sunrise.fill")
            Text("NASCER DO SOL")
        }
        .opacity(0.7)
        .padding(.bottom, 40)
        Text(WeatherFormat.sys(weatherData.sys.sunrise))
            .font(.myFont(size: 30))
        Spacer()
        Text("Pôr do sol: \(WeatherFormat.sys(weatherData.sys.sunset))")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .padding(15)
    .font(.myFont(size: 16))
    .myOverlay(weather: weatherData)
    .padding([.bottom, .leading], 3)
}

func cloudsView(weatherData: WeatherData) -> some View {
    VStack (alignment: .leading) {
        HStack {
            Image(systemName: "cloud.fill")
            Text("NUVENS")
        }
        .opacity(0.7)
        .padding(.bottom, 20)
        HStack {
            Text("\(weatherData.clouds.all)% do céu.")
                .font(.myFont(size: 30))
            Spacer()
            CloudPorcentageView(progress: Double(weatherData.clouds.all))
                .font(.myFont(size: 65))
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .padding(15)
    .font(.myFont(size: 16))
    .myOverlay(weather: weatherData)
    .padding(.bottom, 35)
}

#Preview {
    ZStack {
        ScrollView {
            DetailsWeatherView()
                .padding(.top, 90)
        }
    }
    .environmentObject(LocationManager())
    .environmentObject(WeatherViewModel())
    .environmentObject(ForecastViewModel())
    .environmentObject(Search())
}
