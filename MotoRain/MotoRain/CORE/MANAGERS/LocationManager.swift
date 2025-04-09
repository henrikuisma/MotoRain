//
//  LocationManager.swift
//  MotoRain
//
//  Created by Henri Kuisma on 26.3.2025.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus?
    @Published var address: String = "Fetching location..."
    
    var latitude:Double{
        locationManager.location?.coordinate.latitude ?? 37.322998
    }
    var longitude:Double{
        locationManager.location?.coordinate.longitude ?? -122.032181
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        fetchUserAddress()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorisationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
            
        case .restricted:
            authorisationStatus = .restricted
            break
            
        case .denied:
            authorisationStatus = .denied
            break
            
        case .notDetermined:
            authorisationStatus = .notDetermined
            manager.requestLocation()
            break
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        fetchUserAddress()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("\(error.localizedDescription)")
    }
    
    
    private func fetchUserAddress() {
        guard let location = locationManager.location else { return }
        
        let geocoder = CLGeocoder()
        let userLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(userLocation) { [weak self] placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    self?.address = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.country ?? "")"
                }
            }
        }
    }
}
