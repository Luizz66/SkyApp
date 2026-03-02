//
//  VerticalFadeMask.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 23/02/26.
//

import SwiftUI

struct VerticalFadeMask: ViewModifier {
    func body(content: Content) -> some View {
        content
            .mask(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: .black, location: 0.06),
                        .init(color: .black, location: 0.90),
                        .init(color: .black.opacity(0.1), location: 0.95),
                        .init(color: .clear, location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
}

extension View {
    func verticalFadeMask() -> some View {
        self.modifier(VerticalFadeMask())
    }
}
