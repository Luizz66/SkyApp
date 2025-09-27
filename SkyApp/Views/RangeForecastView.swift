//
//  RangeForecastView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct RangeForecastView : View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var forecastViewModel: ForecastViewModel
    
    var body: some View {
        VStack {
            if let todayTemp = forecastViewModel.todayMinMaxTemp {
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
            } else if let erro = forecastViewModel.errorMessage {
                Text("❌ Erro: \(erro)")
                    .font(.itim(size: 16))
                    .padding(.bottom, 30)
            } else {
                Text("Carregando temperatura...")
                    .font(.itim(size: 17))
            }
        }
        .onReceive(locationManager.$coordinate.compactMap { $0 }) { coordinate in
            forecastViewModel.loadForecast(for: coordinate)
        }
    }
}

#Preview {
    RangeForecastView()
        .environmentObject(LocationManager())
        .environmentObject(ForecastViewModel())
        .preferredColorScheme(.dark)
}
