//
//  ContentView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 14/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            ImgBackgroundView()
            VStack {
                MainForecastView()
                AirHumidityView()
            }
        }
    }
}

struct ImgBackgroundView: View {
    var body: some View {
        Image("dia-sol")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .overlay(
                Color.black.opacity(0.2)
            )
    }

}

struct MainForecastView: View {
    var body: some View {
        VStack {
            Text("Minas Gerais")
                .padding(.bottom, 1)
                .font(.custom("Itim", size: 35))
                .foregroundColor(.white)
            HStack {
                Text("25°C")
                    .foregroundColor(.white)
                    .padding(.trailing, 15)
                Image(systemName: "sun.max.fill")
                    .foregroundColor(.yellow)
                    .animationBounce()
            }
            .font(.custom("Itim", size: 80))
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.white, lineWidth: 2)
        )
        .padding(.bottom)
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
        .padding()
        .font(.custom("Itim", size: 18))
        .foregroundColor(.white)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .opacity(0.3)
        )
        .padding([.trailing, .leading], 70)
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
