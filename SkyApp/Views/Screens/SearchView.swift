//
//  SearchView.swift
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
        NavigationStack {
            List(searchCompleter.suggestions, id: \.self) { suggestion in
                if searchCompleter.queryFragment != "" {
                    Button {
                        locationManager.getSearchLocation(suggestion)
                        isPresented = true
                    } label: {
                        Text(suggestion.title + ", " + suggestion.subtitle)
                    }
                }
            }
            .navigationTitle("Tempo")
            .searchable(
                text: $searchCompleter.queryFragment,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Buscar cidade..."
            )
            .autocorrectionDisabled()
            .listStyle(.plain)
        }
        .fullScreenCover(isPresented: $isPresented) {
            ZStack {
                NavigationStack {
                    GeometryReader { geo in
                        HomeView()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button {
                                        locationManager.searchCoordinate = locationManager.currentCoordinate
                                        isPresented = false
                                    } label: {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                    }
                    .padding(.bottom, 100)
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(LocationManager())
        .environmentObject(WeatherViewModel())
        .environmentObject(ForecastViewModel())
        .environmentObject(Search())
        .preferredColorScheme(.dark)
}
