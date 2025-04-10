//
//  ContentView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import SwiftUI
import CoreLocation

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
        Image(Bg.daySum)
            .scaledToFill()
            .ignoresSafeArea()
            .overlay(
                Color.black.opacity(0.3)
            )
    }
}

struct MainForecastView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let clima = weatherViewModel.weatherData {
                Text("\(clima.name)")
                    .font(.custom("Itim", size: 35))
                    .padding(.bottom, 1)
                HStack {
                    Text("\(clima.main.temp)")
                        .padding(.trailing, 15)
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.yellow)
                        .animationBounce()
                }
                .font(.custom("Itim", size: 80))
            } else if let erro = weatherViewModel.errorMessage {
                Text("Erro: \(erro)")
            } else {
                Text("Carregando clima...")
                    .font(.custom("Itim", size: 35))
                    .padding(.bottom, 1)
            }
        }
        .onReceive(locationManager.$city.dropFirst()) { cidade in
            weatherViewModel.loadWeather(for: cidade)
        }
        .foregroundColor(.white)
        .padding(.top, 50)
        .padding(.bottom, 30)
    }
}

struct AirHumidityView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Umidade")
                Spacer()
                Text("1000mm")
            }
            HStack {
                Text("Vento")
                Spacer()
                Text("10km/h")
            }
        }
        .font(.custom("Itim", size: 19))
        .foregroundColor(.white)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .opacity(0.2)
        )
        .padding([.trailing, .leading], 70)
        .padding(.bottom, 30)
    }
}

struct HourlyForecastView: View {
    var body: some View {
        Text("PREIVSÃO POR HORA")
            .font(.custom("Itim", size: 22))
            .foregroundColor(.white)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0...23, id: \.self) { index in
                    VStack {
                        Text("13:00")
                            .font(.custom("Itim", size: 18))
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.yellow)
                            .padding([.top, .bottom], 0.1)
                            .animationBounce()
                        Text("25°C")
                            .font(.custom("Itim", size: 22))
                        
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: 1).opacity(0.2)
                    )
                    .padding(1)
                }
            }
            .padding(.trailing, 9)
            .padding(.bottom, 20)
        }
        .padding(.leading, 9)
    }
}

struct DaysForecastView: View {
    var body: some View {
        Text("PRÓXIMOS DIAS")
            .font(.custom("Itim", size: 22))
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
    func animationBounce() -> some View {
        self.modifier(BounceEffect())
    }
}

// Modificador customizado para o efeito de bounce
struct BounceEffect: ViewModifier {
    @State private var bounce = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(bounce ? 1.02 : 1.0)
            .offset(y: bounce ? -2 : 0)
            .animation(
                Animation.interpolatingSpring(stiffness: 250, damping: 30)
                    .repeatForever(autoreverses: true), value: bounce
            )
            .onAppear {
                bounce = true
            }
    }
}

#Preview {
    ContentView()
}
