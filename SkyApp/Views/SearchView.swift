//
//  CitySearchView.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 09/12/25.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @StateObject var searchCompleter = SearchCompleterViewModel()
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            TextField("Buscar cidade...", text: $searchCompleter.queryFragment)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            List(searchCompleter.suggestions, id: \.self) { suggestion in
                Button {
                    locationManager.getSearchLocation(suggestion)
                    isPresented = true
                } label: {
                    Text(suggestion.title + ", " + suggestion.subtitle)
                }
            }
        }
        .environmentObject(searchCompleter)
        .sheet(isPresented: $isPresented) { 
            MainView()
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .environmentObject(ForecastViewModel())
        .environmentObject(Search())
}
