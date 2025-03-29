//
//  MapManager.swift
//  MotoRain
//
//  Created by Henri Kuisma on 28.3.2025.
//

import SwiftUI
import MapKit

class MapManager: ObservableObject {
    @ObservedObject var locationManager = LocationManager()
    
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    init() {
        updatePosition()
    }
    
    func updatePosition() {
        let latitude = locationManager.latitude
        let longitude = locationManager.longitude
        position = .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
}
