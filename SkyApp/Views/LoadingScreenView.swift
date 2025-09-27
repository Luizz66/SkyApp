//
//  LoadingScreenView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct LoadingScreenView: View {
    var body: some View {
        ZStack{
            Image("loading")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 70)
                .overlay(
                    Color.black.opacity(0.5)
                )
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2.6)
            }
        }
    }
}

#Preview {
    LoadingScreenView()
}
