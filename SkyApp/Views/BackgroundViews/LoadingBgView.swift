//
//  LoadingBgView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 15/12/25.
//

import SwiftUI

struct LoadingBgView: View {
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
        }
    }
}

#Preview {
    LoadingBgView()
}
