//
//  ShadowStyle.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 05/12/25.
//

import SwiftUI

struct ShadowStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial.opacity(0.4))
                    .blur(radius: 10)
                    .mask(
                        RoundedRectangle(cornerRadius: 20)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black.opacity(0.6), lineWidth: 2)
                    .blur(radius: 9)
                    .mask(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 3)
                    )
            )
    }
}

extension View {
    func shadowCustom() -> some View {
        self.modifier(ShadowStyle())
    }
}
