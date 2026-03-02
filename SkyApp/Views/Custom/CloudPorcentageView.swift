//
//  CloudPorcentageView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 26/09/25.
//

import SwiftUI

struct CloudPorcentageView: View {
    var progress: Double
    
    var body: some View {
        let fillFraction = min(max(progress / 100, 0), 1)
        
        ZStack {
            Image(systemName: "cloud")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            
            Image(systemName: "cloud.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white.opacity(0.7))
                .mask(
                    GeometryReader { geo in
                        Rectangle()
                            .size(width: geo.size.width, height: geo.size.height * fillFraction)
                            .offset(y: geo.size.height * (1 - fillFraction))
                    }
                )
        }
        .frame(width: 100, height: 100)
    }
}

#Preview{
    CloudPorcentageView(progress: 50) 
        .preferredColorScheme(.dark)
}
