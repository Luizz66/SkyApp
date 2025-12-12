//
//  LoadScreenView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct LoadScreenView: View {
    var body: some View {
        ZStack{
            Image("loading")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 85)
                .overlay(
                    Color.black.opacity(0.75)
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
    LoadScreenView()
}
