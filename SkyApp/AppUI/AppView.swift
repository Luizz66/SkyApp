//
//  AppView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//
import SwiftUI

struct AppView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject var weatherViewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            ImgBackgroundView()
            VStack {
                MainForecastView()
                    .ignoresSafeArea(edges: .all)
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
        .environmentObject(weatherViewModel)
    }
}

struct ImgBackgroundView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        ZStack {
            if let clima = weatherViewModel.weatherData {
                Image(backgroundImage(icon: clima.weather[0].icon))
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(
                        clima.weather[0].icon.last == "d" ? Color.black.opacity(0.4) : Color.black.opacity(0.3)
                    )
            } else if let erro = weatherViewModel.errorMessage {
                Text("Erro: \(erro)")
            }
            else {
                LoadingScreenView()
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weatherViewModel.loadWeather(for: coordinate)
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
                    .font(.itim(size: 35))
                    .padding(.bottom, 1)
                HStack {
                    VStack(alignment: .leading) {
                        Text(formatTemp(clima.main.temp))
                            .padding(.trailing, 15)
                        Text(mainDescription(id: clima.weather.first?.id ?? 0))
                            .font(.itim(size: 21))
                            .opacity(0.6)
                    }
                    Image(systemName: SF(icon: clima.weather[0].icon))
                        .myIconStyle(clima.weather[0].icon)
                        .font(.system(size: 90))
                        .myAnimationBounce()
                }
                .font(.itim(size: 85))
            } else if let erro = weatherViewModel.errorMessage {
                Text("Erro: \(erro)")
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weatherViewModel.loadWeather(for: coordinate)
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 50)
        }
        .padding(.bottom, 50)
    }
}

struct RangeForecastView : View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let todayTemp = todayMinMaxTemp {
                HStack {
                    Image(systemName: "thermometer.low")
                        .opacity(0.6)
                    Text(formatIntTemp(txt: "Mín", temp: todayTemp.min))
                        .padding(.trailing, 30)
                    Image(systemName: "thermometer.high")
                        .opacity(0.6)
                    Text(formatIntTemp(txt: "Máx", temp: todayTemp.max))
                }
                .font(.itim(size: 23))
                .padding()
                .background(.white.opacity(0.1))
                .cornerRadius(20)
                .padding(.bottom, 35)
            } else if let erro = weatherViewModel.errorMessage {
                Text("Erro: \(erro)")
            } else {
                ProgressView("Carregando temperatura...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .font(.itim(size: 17))
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weatherViewModel.loadForecast(for: coordinate)
        }
    }
    private var todayMinMaxTemp: (min: Double, max: Double)? {
        guard let list = weatherViewModel.forecastData?.list else { return nil }
        
        let apiFormatter = DateFormatter()
        apiFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        apiFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let calendar = Calendar.current
        let today = Date()
        
        let todayForecasts = list.compactMap { item -> (Double, Double)? in
            guard let date = apiFormatter.date(from: item.dt_txt) else { return nil }
            if calendar.isDate(date, inSameDayAs: today) {
                return (item.main.temp_min, item.main.temp_max)
            }
            return nil
        }
        
        guard !todayForecasts.isEmpty else { return nil }
        
        let minTemp = todayForecasts.map { $0.0 }.min() ?? 0.0
        let maxTemp = todayForecasts.map { $0.1 }.max() ?? 0.0
        return (minTemp, maxTemp)
    }
}

struct DaysForecastView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let _ = weatherViewModel.forecastData {
                HStack {
                    Image(systemName: "calendar")
                    Text("PREVISÃO PARA 5 DIAS")
                }
                .font(.itim(size: 20))
                .opacity(0.6)
                .padding(.bottom, 10)
                ForEach(dailyForecasts.prefix(5), id: \.date) { forecast in
                    HStack {
                        Text(formatDayWeek(from: forecast.date))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: SF(icon: forecast.icon))
                            .myIconStyle(forecast.icon)
                            .myAnimationBounce()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "thermometer.low")
                            .font(.itim(size: 17))
                            .opacity(0.6)
                        Text("\(Int(forecast.tempMin))°")
                            .padding(.trailing, 10)
                        Image(systemName: "thermometer.high")
                            .font(.itim(size: 17))
                            .opacity(0.6)
                        Text("\(Int(forecast.tempMax))°")
                    }
                    .font(.itim(size: 20))
                    Divider()
                        .background(Color.white)
                        .padding(.bottom, 7)
                }
            } else if let erro = weatherViewModel.errorMessage {
                Text("Erro: \(erro)")
            }
        }
        .padding(.bottom, 8)
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weatherViewModel.loadForecast(for: coordinate)
        }
    }
    private var dailyForecasts: [DailyForecast] {
        guard let list = weatherViewModel.forecastData?.list else { return [] }
        
        let grouped = Dictionary(grouping: list) { forecast in
            String(forecast.dt_txt.prefix(10)) // yyyy-mm-dd
        }
        let sortedKeys = grouped.keys.sorted()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date())
        
        let nextDays = sortedKeys.filter { $0 > todayString }
        
        return nextDays.prefix(5).compactMap { date in
            guard let forecasts = grouped[date] else { return nil }
            
            let middayForecast = forecasts.first(where: { $0.dt_txt.contains("12:00:00") })
            
            // Se não encontrar 12:00, pega o primeiro disponível
            let icon = middayForecast?.weather.first?.icon ?? forecasts.first?.weather.first?.icon ?? "01d"
            
            let minTemp = forecasts.map { $0.main.temp_min }.min() ?? 0.0
            let maxTemp = forecasts.map { $0.main.temp_max }.max() ?? 0.0
            return DailyForecast(date: date, icon: icon, tempMin: minTemp, tempMax: maxTemp)
        }
    }
}

struct ForecastDetails: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let clima = weatherViewModel.weatherData {
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
                                Text(formatWind(wind: clima.wind.speed))
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
                        Text(formatTemp(clima.main.feels_like))
                            .font(.itim(size: 30))
                        Spacer()
                        Text(sensationDescription(temp: clima.main.temp, feelsLike: clima.main.feels_like))
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
                        Text(formatPrecipitation(rain: clima.rain?.one ?? 0.0))
                            .font(.itim(size: 30))
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
                        Text(formatSys(from: clima.sys.sunrise))
                            .font(.itim(size: 30))
                        Spacer()
                        Text("Pôr do sol: \(formatSys(from: clima.sys.sunset))")
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
                        Image(systemName: "cloud")
                            .font(.itim(size: 65))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(10)
                .font(.itim(size: 15))
                .background(.white.opacity(0.1))
                .cornerRadius(20)
            } else if let erro = weatherViewModel.errorMessage {
                Text("Erro: \(erro)")
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weatherViewModel.loadWeather(for: coordinate)
        }
    }
}

#Preview {
    AppView()
}
