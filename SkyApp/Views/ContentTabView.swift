//
//  ContentTabView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 09/12/25.
//

import SwiftUI

struct ContentTabView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var forecastViewModel: ForecastViewModel
    @EnvironmentObject var search: Search
    
    @State private var selection = 0
    
    init() {//tabBar with transparent brackground
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
                        .padding(.bottom, -5)
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
        .onReceive(locationManager.coordinatePublisher(isSearch: search.isSearch).compactMap { $0 }) { coordinate in
            Task {
                await weatherViewModel.loadWeather(for: coordinate)
                await forecastViewModel.loadForecast(for: coordinate)
            }
        }
        .onChange(of: selection) { _, newTab in
            search.isSearch = (newTab == 1)
        }
    }
}

#Preview {
    ContentTabView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .environmentObject(ForecastViewModel())
        .environmentObject(Search())
        .preferredColorScheme(.dark)
}
