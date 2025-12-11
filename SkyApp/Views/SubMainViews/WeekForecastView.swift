//
//  WeekForecastView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct WeekForecastView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var forecastViewModel: ForecastViewModel
    
    @EnvironmentObject var search: Search
    
    var body: some View {
        VStack {
            if let _ = forecastViewModel.forecastData {
                HStack {
                    Image(systemName: "calendar")
                    Text("PREVISÃO PARA 5 DIAS")
                }
                .font(.itim(size: 20))
                .opacity(0.7)
                .padding(.bottom, 15)
                .padding(.top, 40)
                
                ForEach(forecastViewModel.dailyForecasts.prefix(5), id: \.date) { forecast in
                    
                    dayView(daily: forecast)
                }
            } else if let erro = forecastViewModel.errorMessage {
                GeometryReader { geo in
                    VStack {
                        Text("❌ \(erro.uppercased())")
                            .font(.itim(size: 16))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, geo.size.height * 40)
                    }                    
                    .frame(width: geo.size.width / 1.3, height: geo.size.height)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .padding(.bottom, 20)
        .onReceive(locationManager.coordinatePublisher(isSearch: search.isSearch).compactMap { $0 }) { coordinate in
            forecastViewModel.loadForecast(for: coordinate)
        }
    }
}

func dayView(daily dailyForecast: DailyForecast) -> some View {
    VStack {
        HStack {
            Text(dailyForecast.date)
                .frame(maxWidth: .infinity, alignment: .leading)
                .shadow(color: .black, radius: 1)
            
            Spacer()
            
            Label { 
                Text(dailyForecast.formattedTemp.min)
                    .shadow(color: .black, radius: 1)
            } icon: { 
                Image(systemName: "thermometer.low")
                    .foregroundStyle(.blue, .white)
                    .opacity(0.8)
            }
            .padding(.trailing, 20)
            
            Label { 
                Text(dailyForecast.formattedTemp.max)
                    .shadow(color: .black, radius: 1)
            } icon: { 
                Image(systemName: "thermometer.high")
                    .foregroundStyle(.red, .white)
                    .opacity(0.8)
            }
        }
        .font(.itim(size: 20))
        .overlay(alignment: .leading) {
            GeometryReader { geo in
                Image(systemName: dailyForecast.mySFSymbol)
                    .symbolStyle(dailyForecast.icon)
                    .animationBounce()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .shadow(color: .black, radius: 1)
                    .offset(x: geo.size.width * 0.35)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 10)
        .overlay(
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.white.opacity(0.4))
                    .frame(height: 0.7)
            }
        )
    }
}

#Preview {
    WeekForecastView()
        .environmentObject(LocationManager())
        .environmentObject(ForecastViewModel())
        .environmentObject(Search()) 
        .preferredColorScheme(.dark)
}
