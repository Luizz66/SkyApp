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
                        clima.weather[0].icon.last == "d" ? Color.black.opacity(0.3) : Color.black.opacity(0.2)
                    )
            } else if let erro = weatherViewModel.errorMessage {
                Text("Erro: \(erro)")
            }
            else {
                Text("...")
                    .font(.itim(size: 35))
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
                        Text(formatTemp(temp: clima.main.temp))
                            .padding(.trailing, 15)
                        Text(mainDescription(id: clima.weather.first?.id ?? 0))
                            .font(.itim(size: 21))
                            .opacity(0.6)
                    }
                    Image(systemName: mainIcon(icon: clima.weather[0].icon))
                        .font(.system(size: 90))
                        .foregroundColor(Color("color-sun"))
                        .myAnimationBounce()
                }
                .font(.itim(size: 85))
            } else if let erro = weatherViewModel.errorMessage {
                Text("Erro: \(erro)")
            } else {
                Text("Carregando...")
                    .font(.itim(size: 35))
                    .padding(.bottom, 1)
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

struct TemperatureRangeView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let clima = weatherViewModel.weatherData {
                HStack {
                    Image(systemName: "thermometer.low")
                        .opacity(0.6)
                    Text(formatRangeTemp(txt: "Mín", temp: clima.main.temp_min))
                        .padding(.trailing, 30)
                    Image(systemName: "thermometer.high")
                        .opacity(0.6)
                    Text(formatRangeTemp(txt: "Máx", temp: clima.main.temp_max))
                }
                .font(.itim(size: 23))
                .padding()
                .background(.white.opacity(0.1))
                .cornerRadius(20)
                .padding(.bottom, 35)
            } else if let erro = weatherViewModel.errorMessage {
                Text("Erro: \(erro)")
            } else {
                Text("Carregando...")
                    .font(.itim(size: 35))
                    .padding(.bottom, 1)
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
        .font(.itim(size: 20))
        .opacity(0.6)
        .padding(.bottom, 10)
        VStack {
            ForEach(0...4, id: \.self) { item in
                HStack {
                    Text("Ter.")
                    Spacer()
                    Image(systemName: "cloud.drizzle.fill")
                        .myAnimationBounce()
                    Spacer()
                    Image(systemName: "thermometer.low")
                        .font(.itim(size: 17))
                        .opacity(0.6)
                    Text(" 25°")
                        .padding(.trailing, 10)
                    Image(systemName: "thermometer.high")
                        .font(.itim(size: 17))
                        .opacity(0.6)
                    Text(" 35°")
                }
                .font(.itim(size: 20))
                Divider()
                    .background(Color.white)
                    .padding(.bottom, 7)
            }
        }
        .padding(.bottom, 8)
    }
}

struct ForecastDetails: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let clima = weatherViewModel.weatherData {
                HStack {
                    VStack {
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
                    //
                    VStack (alignment: .leading) {
                        HStack {
                            Image(systemName: "thermometer.medium")
                            Text("SENSAÇÃO")
                        }
                        .opacity(0.6)
                        .padding(.bottom, 0.1)
                        Text(formatTemp(temp: clima.main.feels_like))
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
                //
                HStack {
                    VStack (alignment: .leading) {
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
                    //
                    VStack (alignment: .leading) {
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
                //
                VStack (alignment: .leading) {
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
            } else {
                Text("Carregando...")
                    .font(.itim(size: 35))
                    .padding(.bottom, 1)
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            weatherViewModel.loadWeather(for: coordinate)
        }
    }
}

extension View {
    func respectSafeAre() -> some View {
        self.safeAreaInset(edge: .top) {
            GeometryReader { geometry in
                Color.clear
                    .frame(height: geometry.safeAreaInsets.top )
            }
            .frame(height: 0)
        }
    }
}

// Extensão para adicionar a animação de bounce
extension View {
    func myAnimationBounce() -> some View {
        self.modifier(MyBounceEffect())
    }
}

// Modificador customizado para o efeito de bounce
struct MyBounceEffect: ViewModifier {
    @State private var bounce = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(bounce ? 1.04 : 1.0)
            .offset(y: bounce ? -1 : 0)
            .animation(
                Animation.easeInOut(duration: 0.6)
                    .repeatForever(autoreverses: true),
                value: bounce
            )
            .onAppear {
                bounce = true
            }
    }
}

#Preview {
    SkyAppView()
}
