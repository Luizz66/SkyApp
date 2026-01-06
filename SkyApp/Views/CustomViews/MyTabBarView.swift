//
//  MyTabBarView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 10/12/25.
//

import SwiftUI

//if #unavailable(iOS 26)
struct MyTabBarView: View {
    @Binding var selection: Int
    
    var body: some View {
        HStack {
            tabButton(icon: "location", tag: 0)
            tabButton(icon: "magnifyingglass", tag: 1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 7)
        .background(
            ZStack {
                Color.white.opacity(0.2) 
                    .blur(radius: 15)
            }
                .clipShape(RoundedRectangle(cornerRadius: 33))
                .shadow(color: .black, radius: 6)
        )
    }
    
    func tabButton(icon: String, tag: Int) -> some View {
        Button {
            selection = tag
        } label: {
            Image(systemName: icon)
                .font(.system(size: 25, weight: .medium))
                .foregroundStyle(selection == tag ? .blue : .white)
                .padding(12)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.foreground)
                        .blur(radius: 15)
                        .opacity(selection == tag ? 0.6 : 0)
                )
                .clipShape(RoundedRectangle(cornerRadius: 23))
        }
        .buttonStyle(.plain)
    }
}
