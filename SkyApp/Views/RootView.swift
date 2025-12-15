//
//  RootView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 09/12/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var search: Search
    
    @State private var selection = 0
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        Group {
            if #unavailable(iOS 26) {
                ZStack(alignment: .bottom) {
                    TabView(selection: $selection) {
                        HomeView().tag(0)
                        SearchView().tag(1)
                    }
                    
                    MyTabBarView(selection: $selection)
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
            } else {
                TabView(selection: $selection) {
                    HomeView()
                        .tag(0)
                        .tabItem {
                            Image(systemName: "location")
                        }
                    
                    SearchView()
                        .tag(1)
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                        }
                }
            }
        }
        .onChange(of: selection) { _, newTab in
            search.isSearch = (newTab == 1)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .environmentObject(ForecastViewModel())
        .environmentObject(Search())
}
