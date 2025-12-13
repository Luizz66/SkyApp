//
//  ContentView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 09/12/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var search: Search
    
    @State private var selection = 0
    
    var body: some View {
        Group {
            if #unavailable(iOS 26) {
                ZStack(alignment: .bottom) {
                    TabView(selection: $selection) {
                        MainView().tag(0)
                        SearchView().tag(1)
                    }
                    
                    CustomTabBarView(selection: $selection)
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
            } else {
                TabView(selection: $selection) {
                    MainView()
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
        .preferredColorScheme(.dark)
        .onChange(of: selection) { _, newTab in
            search.isSearch = (newTab == 1)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .environmentObject(ForecastViewModel())
        .environmentObject(Search())
}
