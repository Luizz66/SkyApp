//
//  CustomTabBar.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 10/12/25.
//

import SwiftUI

//if #unavailable(iOS 26)
struct CustomTabBar: View {
    @Binding var selection: Int
    
    var body: some View {
        HStack {
            tabButton(icon: "location", tag: 0)
            tabButton(icon: "magnifyingglass", tag: 1)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            ZStack {
                Color.black.opacity(0.2)
                    .blur(radius: 15)
                
                Color.gray.opacity(0.2)
                    .blur(radius: 15)
            }
                .clipShape(RoundedRectangle(cornerRadius: 25))
        )
        .padding(.bottom, 10)
    }
    
    func tabButton(icon: String, tag: Int) -> some View {
        Button {
            selection = tag
        } label: {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(selection == tag ? .blue : .white)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 13)
                        .fill(.ultraThinMaterial)
                        .opacity(selection == tag ? 0.6 : 0)
                )
                .clipShape(RoundedRectangle(cornerRadius: 13))
        }
        .buttonStyle(.plain)
    }
}
