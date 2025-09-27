//
//  BounceEffect.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 15/09/25.
//

import Foundation
import SwiftUI

struct BounceEffect: ViewModifier {
    @State private var bounce = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(bounce ? 1.04 : 1.0)
            .offset(y: bounce ? -1 : 0)
            .animation(
                Animation.easeInOut(duration: 0.6)
                    .repeatForever(autoreverses: true),
                value: bounce
            )
            .onAppear {
                bounce = true
            }
    }
}

extension View {
    func animationBounce() -> some View {
        self.modifier(BounceEffect())
    }
}
