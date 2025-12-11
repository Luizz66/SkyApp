//
//  DetailsForecastView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct DetailsWeatherView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    @EnvironmentObject var search: Search
    
    var body: some View {
        VStack {
            if let clima = weatherViewModel.weatherData {
                HStack {
                    humidityAndWindView(weatherData: clima)
                    SensationView(weatherData: clima)
                }
                HStack {
                    PrecipitationView(weatherData: clima)
                    Sunriseview(weatherData: clima)
                }
                CloudsView(weatherData: clima)
            }
        }
        .onReceive(locationManager.coordinatePublisher(isSearch: search.isSearch).compactMap { $0 }) { coordinate in
            weatherViewModel.loadWeather(for: coordinate)
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
                    .font(.itim(size: 30))
            }
            
            VStack (alignment: .leading) {
                HStack {
                    Image(systemName: "wind")
                    Text("VENTO")
                }
                .opacity(0.7)
                .padding(.bottom, 20)
                Text(weatherData.formattedWind)
                    .font(.itim(size: 30))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(15)
        .font(.itim(size: 16))
        .shadowCustom()
        .padding(.bottom, 3)
    }
    .padding(.trailing, 3)
}

func SensationView(weatherData: WeatherData) -> some View {
    VStack (alignment: .leading) {
        HStack {
            Image(systemName: "thermometer.medium")
            Text("SENSAÇÃO")
        }
        .opacity(0.7)
        .padding(.bottom, 20)
        Text(weatherData.formattedTemp.feelsLike)
            .font(.itim(size: 30))
        Spacer()
        Text(weatherData.sensationDescription)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .padding(15)
    .font(.itim(size: 16))
    .shadowCustom()
    .padding([.bottom, .leading], 3)
}

func PrecipitationView(weatherData: WeatherData) -> some View {
    VStack (alignment: .leading) {
        HStack {
            Image(systemName: "drop.fill")
            Text("PRECIPITAÇÃO")
        }
        .opacity(0.7)
        .padding(.bottom, 40)
        Text(weatherData.formattedPrecipitation) 
            .font(.itim(size: 30))
            .padding(.bottom, 50)
        Spacer()
        Text("nas últimas 1h.")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .padding(15)
    .font(.itim(size: 16))
    .shadowCustom()
    .padding([.bottom, .trailing], 3)
}

func Sunriseview(weatherData: WeatherData) -> some View {
    VStack (alignment: .leading) {
        HStack {
            Image(systemName: "sunrise.fill")
            Text("NASCER DO SOL")
        }
        .opacity(0.7)
        .padding(.bottom, 40)
        Text(weatherData.formattedSys.sunrise)
            .font(.itim(size: 30))
        Spacer()
        Text("Pôr do sol: \(weatherData.formattedSys.sunset)")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .padding(15)
    .font(.itim(size: 16))
    .shadowCustom()
    .padding([.bottom, .leading], 3)
}

func CloudsView(weatherData: WeatherData) -> some View {
    VStack (alignment: .leading) {
        HStack {
            Image(systemName: "cloud.fill")
            Text("NUVENS")
        }
        .opacity(0.7)
        .padding(.bottom, 20)
        HStack {
            Text("\(weatherData.clouds.all)% do céu.")
                .font(.itim(size: 30))
            Spacer()
            SymbolPorcentageView(progress: Double(weatherData.clouds.all))
                .font(.itim(size: 65))
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .padding(15)
    .font(.itim(size: 16))
    .shadowCustom()
    .padding(.bottom, 35)
}

#Preview {
    ZStack {
        BackgroundImgView()
        ScrollView {
            DetailsWeatherView()
                .padding(.top, 90)
        }
    }
    .environmentObject(LocationManager())
    .environmentObject(WeatherViewModel())
    .environmentObject(Search()) 
}
