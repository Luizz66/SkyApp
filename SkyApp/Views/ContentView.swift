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
        TabView(selection: $selection) {
            
            MainView()
                .tag(0)
                .tabItem {
                    Label("", systemImage: "location")
                }
            
            SearchView()
                .tag(1)
                .tabItem {
                    Label("", systemImage: "magnifyingglass")
                }
        }
        .onChange(of: selection) { newTab in
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
