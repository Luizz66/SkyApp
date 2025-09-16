//
//  ContentView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject var weather = Weather()
    
    var body: some View {
        ZStack {
            ImgBackgroundView()
            VStack {
                MainForecastView()
                ScrollView(.vertical, showsIndicators: false) {
                    RangeForecastView()
                    DaysForecastView()
                    ForecastDetails()
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 30)
                .cornerRadius(25)
            }
            .foregroundColor(.white)
        }
        .environmentObject(locationManager)
        .environmentObject(weather)
    }
}

struct ImgBackgroundView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weather: Weather
    
    var body: some View {
        VStack {
            if let clima = weather.weatherData {
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
            weather.loadWeather(for: coordinate)
        }
    }
}

struct MainForecastView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weather: Weather
    
    var body: some View {
        VStack {
            if let clima = weather.weatherData {
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
            } else if let erro = weather.errorMessage {
                Text("❌ Erro: \(erro)")
                    .font(.itim(size: 16))
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weather.loadWeather(for: coordinate)
        }
        .safeAreaPadding(.top, 85)
        .padding(.bottom, 50)
    }
}

struct RangeForecastView : View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weather: Weather
    
    var body: some View {
        VStack {
            if let todayTemp = weather.todayMinMaxTemp {
                HStack {
                    Image(systemName: "thermometer.low")
                        .foregroundStyle(.blue.opacity(0.6), .white)
                        .opacity(0.6)
                    Text(todayTemp.min)
                        .padding(.trailing, 30)
                    Image(systemName: "thermometer.high")
                        .foregroundStyle(.red.opacity(0.6), .white)
                        .opacity(0.6)
                    Text(todayTemp.max)
                }
                .font(.itim(size: 23))
                .padding()
                .background(.white.opacity(0.1))
                .cornerRadius(20)
                .padding(.bottom, 40)
            } else if let erro = weather.errorMessage {
                Text("❌ Erro: \(erro)")
                    .font(.itim(size: 16))
                    .padding(.bottom, 30)
            } else {
                Text("Carregando temperatura...")
                    .font(.itim(size: 17))
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weather.loadForecast(for: coordinate)
        }
    }
}

struct DaysForecastView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weather: Weather
    
    var body: some View {
        VStack {
            if let _ = weather.forecastData {
                HStack {
                    Image(systemName: "calendar")
                    Text("PREVISÃO PARA 5 DIAS")
                }
                .font(.itim(size: 20))
                .opacity(0.6)
                .padding(.bottom, 10)
                ForEach(weather.dailyForecasts.prefix(5), id: \.date) { forecast in
                    HStack {
                        Text(forecast.date)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: forecast.mySFSymbol)
                            .symbolStyle(forecast.icon)
                            .animationBounce()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "thermometer.low")
                            .foregroundStyle(.blue.opacity(0.6), .white)
                            .font(.itim(size: 17))
                            .opacity(0.6)
                        Text(forecast.formattedTemp.min)
                            .padding(.trailing, 10)
                        Image(systemName: "thermometer.high")
                            .foregroundStyle(.red.opacity(0.6), .white)
                            .font(.itim(size: 17))
                            .opacity(0.6)
                        Text(forecast.formattedTemp.max)
                    }
                    .font(.itim(size: 20))
                    Divider()
                        .background(Color.white)
                        .padding(.bottom, 7)
                }
            } else if let erro = weather.errorMessage {
                Text("❌ Erro: \(erro)")
                    .font(.itim(size: 16))
                    .padding(.bottom, 20)
            }
        }
        .padding(.bottom, 8)
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weather.loadForecast(for: coordinate)
        }
    }
}

struct ForecastDetails: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weather: Weather
    
    var body: some View {
        VStack {
            if let clima = weather.weatherData {
                HStack {
                    VStack /*umidade e vento*/ {
                        Group {
                            VStack (alignment: .leading) {
                                HStack {
                                    Image(systemName: "humidity.fill")
                                    Text("UMIDADE")
                                }
                                .opacity(0.6)
                                .padding(.bottom, 0.1)
                                Text("\(clima.main.humidity)%")
                                    .font(.itim(size: 30))
                            }
                            VStack (alignment: .leading) {
                                HStack {
                                    Image(systemName: "wind")
                                    Text("VENTO")
                                }
                                .opacity(0.6)
                                .padding(.bottom, 0.1)
                                Text(clima.formattedWind)
                                    .font(.itim(size: 30))
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(8)
                        .font(.itim(size: 15))
                        .background(.white.opacity(0.1))
                        .cornerRadius(20)
                    }
                    VStack (alignment: .leading) /*sensação*/ {
                        HStack {
                            Image(systemName: "thermometer.medium")
                            Text("SENSAÇÃO")
                        }
                        .opacity(0.6)
                        .padding(.bottom, 0.1)
                        Text(clima.formattedTemp.feelsLike)
                            .font(.itim(size: 30))
                        Spacer()
                        Text(clima.sensationDescription)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(8)
                    .font(.itim(size: 15))
                    .background(.white.opacity(0.1))
                    .cornerRadius(20)
                }
                HStack {
                    VStack (alignment: .leading) /*precipitação*/ {
                        HStack {
                            Image(systemName: "drop.fill")
                            Text("PRECIPITAÇÃO")
                        }
                        .opacity(0.6)
                        .padding(.bottom, 0.1)
                        Text(clima.formattedPrecipitation)                            .font(.itim(size: 30))
                            .padding(.bottom, 50)
                        Spacer()
                        Text("nas últimas 1h.")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(8)
                    .font(.itim(size: 15))
                    .background(.white.opacity(0.1))
                    .cornerRadius(20)
                    VStack (alignment: .leading) /*nascer do sol*/ {
                        HStack {
                            Image(systemName: "sunrise.fill")
                            Text("NASCER DO SOL")
                        }
                        .opacity(0.6)
                        .padding(.bottom, 0.1)
                        Text(clima.formattedSys.sunrise)
                            .font(.itim(size: 30))
                        Spacer()
                        Text("Pôr do sol: \(clima.formattedSys.sunset)")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(8)
                    .font(.itim(size: 15))
                    .background(.white.opacity(0.1))
                    .cornerRadius(20)
                }
                VStack (alignment: .leading) /*nuvens*/ {
                    HStack {
                        Image(systemName: "cloud.fill")
                        Text("NUVENS")
                    }
                    .opacity(0.6)
                    .padding(.bottom, 0.1)
                    HStack {
                        Text("\(clima.clouds.all)% do céu.")
                            .font(.itim(size: 30))
                        Spacer()
                        SymbolPorcentageView(progress: Double(clima.clouds.all))
                            .font(.itim(size: 65))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(10)
                .font(.itim(size: 15))
                .background(.white.opacity(0.1))
                .cornerRadius(20)
            } else if let erro = weather.errorMessage {
                Text("❌ Erro: \(erro)")
                    .font(.itim(size: 16))
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weather.loadWeather(for: coordinate)
        }
    }
}

struct SymbolPorcentageView: View {
    var progress: Double
    
    var body: some View {
        let fillFraction = min(max(progress / 100, 0), 1)
        
        ZStack {
            Image(systemName: "cloud")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            
            Image(systemName: "cloud.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white.opacity(0.6))
                .mask(
                    GeometryReader { geo in
                        Rectangle()
                            .size(width: geo.size.width, height: geo.size.height * fillFraction)
                            .offset(y: geo.size.height * (1 - fillFraction))
                    }
                )
        }
        .frame(width: 100, height: 100)
    }
}

struct LoadingScreenView: View {
    var body: some View {
        ZStack{
            Image("loading")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 70)
                .overlay(
                    Color.black.opacity(0.5)
                )
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2.6)
            }
        }
    }
}

#Preview {
    ContentView()
}
