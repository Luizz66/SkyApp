//
//  GeocodingViewModel.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 12/12/25.
//

import Foundation

class GeocodingViewModel: ObservableObject {
    @Published var geocodingData: GeocodingData?
    @Published var errorMessage: String?
    
    private let apiService = APIService()
    
    func loadGeocode(for city: String) async {
        do {
            let dados = try await apiService.fetchGeocode(for: city)
            await MainActor.run {
                self.geocodingData = dados.first
                self.errorMessage = nil
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.geocodingData = nil
            }
        }
    }
    
    var cityTranslate: String? {
        geocodingData?.local_names.pt
    }
}
