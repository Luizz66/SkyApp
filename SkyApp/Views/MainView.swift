//
//  MainView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack {
            BackgroundImgView()
            VStack {
                WeatherMainView()
                ScrollView(.vertical, showsIndicators: false) {
                    WeekForecastView()
                    DetailsWeatherView()
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 30)
                .mask(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0.0),
                            .init(color: .black, location: 0.06),
                            .init(color: .black, location: 0.90),
                            .init(color: .black.opacity(0.1), location: 0.95),
                            .init(color: .clear, location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .environmentObject(ForecastViewModel())
        .environmentObject(Search())
        .preferredColorScheme(.dark)
}
