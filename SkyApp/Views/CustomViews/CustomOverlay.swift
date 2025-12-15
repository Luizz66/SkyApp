//
//  ShadowStyle.swift
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
                        .fill(Color.overlayStyle(icon: clim.weather[0].icon).opacity(0.8))
                        .overlay(Color.black.opacity(0.2))
                        .blur(radius: 5)
                        .mask(
                            RoundedRectangle(cornerRadius: 20)
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.clear, lineWidth: 2)
                        .blur(radius: 2)
                        .mask(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 3)
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
