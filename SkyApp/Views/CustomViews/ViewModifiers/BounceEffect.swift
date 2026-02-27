//
//  BounceEffect.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 15/09/25.
//

import SwiftUI

struct BounceEffect: ViewModifier {
    @State private var animate = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(animate ? 1.04 : 1.0)
            .offset(y: animate ? -3 : 0)
            .task {
                animate = true
            }
            .animation(
                .easeInOut(duration: 1.4).repeatForever(autoreverses: true),
                value: animate
            )
    }
}

extension View {
    func myAnimation() -> some View {
        self.modifier(BounceEffect())
    }
}

#Preview {
    VStack {
        Image(systemName: "cloud.drizzle.fill")
            .myAnimation()
            .font(.system(size: 200))
    }
}
