//
//  BackgroundView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct BackgroundView: View {
    let weather: WeatherData?
    
    var body: some View {
        VStack {
            if let clim = weather {
                Image(Background.style(icon: clim.weather[0].icon))
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                    .overlay(Color.black.opacity(0.4))
            }
        }
    }
}

#Preview {
    BackgroundView(weather: WeatherViewModel().weatherData)
        .preferredColorScheme(.dark)
 }
