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
    
    var body: some View {
        VStack {
            if let _ = forecastViewModel.forecastData {
                HStack {
                    Image(systemName: "calendar")
                    Text("PREVISÃO PARA 5 DIAS")
                }
                .font(.itim(size: 20))
                .opacity(0.6)
                .padding(.bottom, 10)
                ForEach(forecastViewModel.dailyForecasts.prefix(5), id: \.date) { forecast in
                    DayView(dailyForecast: forecast)
                }
            } else if let erro = forecastViewModel.errorMessage {
                Text("❌ Erro: \(erro)")
                    .font(.itim(size: 16))
                    .padding(.bottom, 20)
            }
        }
        .padding(.bottom, 8)
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            forecastViewModel.loadForecast(for: coordinate)
        }
    }
}

struct DayView: View {
    var dailyForecast: DailyForecast
    
    var body: some View {
        HStack {
            Text(dailyForecast.date)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: dailyForecast.mySFSymbol)
                .symbolStyle(dailyForecast.icon)
                .animationBounce()
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "thermometer.low")
                .foregroundStyle(.blue.opacity(0.6), .white)
                .font(.itim(size: 17))
                .opacity(0.6)
            Text(dailyForecast.formattedTemp.min)
                .padding(.trailing, 10)
            Image(systemName: "thermometer.high")
                .foregroundStyle(.red.opacity(0.6), .white)
                .font(.itim(size: 17))
                .opacity(0.6)
            Text(dailyForecast.formattedTemp.max)
        }
        .font(.itim(size: 20))
        Divider()
            .background(Color.white)
            .padding(.bottom, 7)
    }
}

#Preview {
    WeekForecastView()
        .environmentObject(LocationManager())
        .environmentObject(ForecastViewModel())
        .preferredColorScheme(.dark)
}
