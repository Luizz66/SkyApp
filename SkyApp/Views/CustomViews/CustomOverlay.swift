//
//  CustomOverlay.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 05/12/25.
//

import SwiftUI

struct CustomOverlay: ViewModifier {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    func body(content: Content) -> some View {
        if let clim = weatherViewModel.weatherData {
            content
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.overlayStyle(icon: clim.weather[0].icon).opacity(0.3))
                        .overlay(Color.black.opacity(0.1))
                        .blur(radius: 3)
                        .mask(
                            RoundedRectangle(cornerRadius: 20)
                        )
                )
        }
    }
}

extension View {
    func myOverlay() -> some View {
        self.modifier(CustomOverlay())
    }
}
