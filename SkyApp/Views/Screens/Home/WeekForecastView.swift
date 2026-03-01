//
//  WeekForecastView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct WeekForecastView: View {
    @EnvironmentObject var forecastViewModel: ForecastViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "calendar")
                Text("PREVISÃO PARA 5 DIAS")
            }
            .font(.myFont(size: 20))
            .opacity(0.7)
            .padding(.bottom, 15)
            .padding(.top, 40)
            
            ForEach(forecastViewModel.dailyForecasts.prefix(5), id: \.date) { forecast in
                
                dayView(daily: forecast)
            }
        }
        .padding(.bottom, 20)
    }
}

func dayView(daily dailyForecast: DailyForecast) -> some View {
    VStack {
        HStack {
            Text(dailyForecast.date)
                .frame(maxWidth: .infinity, alignment: .leading)
                .shadow(color: .black, radius: 0.8)
            
            Label { 
                Text(ForecastFormat.range(dailyForecast.tempMax))
                    .shadow(color: .black, radius: 0.8)
            } icon: { 
                Image(systemName: "thermometer.high")
                    .font(.system(size: 18))
                    .foregroundStyle(.red.opacity(0.6), .white)
                    .opacity(0.8)
            }
        }
        .font(.myFont(size: 20))
        .overlay(alignment: .leading) {
            GeometryReader { geo in
                Image(systemName: Icons.myIcon(dailyForecast.icon))
                    .iconStyle(dailyForecast.icon)
                    .myAnimation()
                    .id(UUID()) // Force to recreate icon
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .shadow(color: .black, radius: 0.8)
                    .offset(x: geo.size.width * 0.35)
                    .padding(.top, 2)
            }
        }
        .overlay(alignment: .leading) { 
            GeometryReader { geo in
                Label { 
                    Text(ForecastFormat.range(dailyForecast.tempMin))
                        .shadow(color: .black, radius: 0.8)
                } icon: { 
                    Image(systemName: "thermometer.low")
                        .font(.system(size: 18))
                        .foregroundStyle(.blue.opacity(0.6), .white)
                        .opacity(0.8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(x: geo.size.width * 0.65)
            }
            .font(.myFont(size: 20))
        }
        .padding(.vertical, 10)
        .overlay(
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.white.opacity(0.4))
                    .frame(height: 1)
            }
        )
    }
}

#Preview {
    WeekForecastView()
        .environmentObject(ForecastViewModel())
        .preferredColorScheme(.dark)
}
