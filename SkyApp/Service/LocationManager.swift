//
//  LocationManager.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 15/09/25.
//

import CoreLocation
import MapKit

//get current location
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
        
    @Published var currentCoordinate: CLLocationCoordinate2D?
    @Published var searchCoordinate: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentCoordinate = location.coordinate
        }
    }
    
    func getSearchLocation(_ suggestion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: suggestion)
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            if let location = response?.mapItems.first?.placemark.location {
                self.searchCoordinate = location.coordinate
            }
        }
    }
    
    func coordinatePublisher(isSearch: Bool) -> Published<CLLocationCoordinate2D?>.Publisher {
        return isSearch ? $searchCoordinate : $currentCoordinate
    }
}
