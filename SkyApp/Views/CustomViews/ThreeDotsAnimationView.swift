//
//  ThreeDotsAnimationView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 13/12/25.
//

import SwiftUI

struct ThreeDotsAnimationView: View {
    @State private var dotOpacity: [Double] = [1.0, 0.0, 0.0]
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.white)
                    .opacity(dotOpacity[index])
            }
        }
        .onAppear {
            animateDots()
        }
    }
    
    private func animateDots() {
        withAnimation(Animation.easeInOut(duration: 0.75).repeatForever(autoreverses: true)) {
            dotOpacity = [0.0, 1.0, 0.0]  // Ciclo inicial
        }
        
        // Ajusta para animar os outros pontos depois de um intervalo
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(Animation.easeInOut(duration: 0.75).repeatForever(autoreverses: true)) {
                dotOpacity = [0.0, 0.0, 1.0]
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.easeInOut(duration: 0.75).repeatForever(autoreverses: true)) {
                dotOpacity = [1.0, 0.0, 0.0]
            }
        }
    }
}

#Preview {
    ThreeDotsAnimationView()
        .preferredColorScheme(.dark)
}
