//
//  MotoRainMapViewRepresentable.swift
//  MotoRain
//
//  Created by Henri Kuisma on 30.3.2025.
//

import SwiftUI
import MapKit


struct MapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    let locationManager = LocationManager()
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = context.coordinator
        mapView.showsCompass = true
        
        return mapView
    }
    
    func updateUIView(_ view: UIViewType, context: Context) {
        if let selectedLocation = locationViewModel.selectedLocation {
            print("selectedLocation: \(selectedLocation)")
        }
        if locationViewModel.shouldCenterUser {
            context.coordinator.hasCenteredOnUser = false
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
    
        
}

extension MapViewRepresentable {
    
    class MapCoordinator : NSObject, MKMapViewDelegate {
        let parent: MapViewRepresentable
        var hasCenteredOnUser = false
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            guard parent.locationViewModel.shouldCenterUser, !hasCenteredOnUser else { return }

            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )

            parent.mapView.setRegion(region, animated: true)
            hasCenteredOnUser = true
            parent.locationViewModel.shouldCenterUser = false
        }
    }
}
