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
            .offset(y: animate ? -1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
    }
}


extension View {
    func myAnimation() -> some View {
        self.modifier(BounceEffect())
    }
}
