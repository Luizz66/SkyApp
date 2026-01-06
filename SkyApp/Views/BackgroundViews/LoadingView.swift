//
//  LoadingView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 15/12/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack{
            Image("loadingBG")
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
                    .scaleEffect(1.8)
            }
        }
    }
}

#Preview {
    LoadingView()
}
