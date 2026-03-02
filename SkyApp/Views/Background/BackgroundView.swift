//
//  BackgroundView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct BackgroundView: View {
    let weatherIcon: String?
    
    var body: some View {
        VStack {
            if let clim = weatherIcon {
                Image(Background.img(icon: clim))
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
    BackgroundView(weatherIcon: Background.img(icon: "01d"))
        .preferredColorScheme(.dark)
 }
