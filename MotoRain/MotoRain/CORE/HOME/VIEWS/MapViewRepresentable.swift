//
//  MapViewRepresentable.swift
//  MotoRain
//
//  Created by Henri Kuisma on 30.3.2025.
//

import SwiftUI
import MapKit


struct MapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = context.coordinator
        mapView.showsCompass = true
        
        return mapView
    }
    
    func updateUIView(_ view: UIViewType, context: Context) {
        if let coordinate = locationViewModel.selectedLocationCoordinate {
            print("Selected location coordinate: \(coordinate)")
            context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
            context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
        }
        if locationViewModel.shouldCenterUser {
            
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
    
        
}

extension MapViewRepresentable {
    
    class MapCoordinator : NSObject, MKMapViewDelegate {
        let parent: MapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
            self.userLocationCoordinate = userLocation.coordinate
            //print("User location updated: \(userLocation.coordinate)")
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )

            parent.mapView.setRegion(region, animated: true)
            
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else {
                //print("User location is not set")
                return
            }
            //print("Configuring polyline from \(userLocationCoordinate) to \(coordinate)")
            getDestinationRoute(from: userLocationCoordinate,
                                to: coordinate) { route in
                //print("Adding route overlay")
                self.parent.mapView.addOverlay(route.polyline)
            }
        }
        
        func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                                 to destination: CLLocationCoordinate2D,
                                 completion: @escaping(MKRoute) -> Void) {
            
            let userPlacemark = MKPlacemark(coordinate: userLocation)
            let destPlacemark = MKPlacemark(coordinate: destination)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destPlacemark)
            let directions = MKDirections(request: request)
            
            directions.calculate { response, error in
                if let error = error {
                    print("Error calculating directions: \(error.localizedDescription)")
                    return
                }
                guard let route = response?.routes.first else { return } // changing later to respond to possible rain
                completion(route)
            }
                
        }
    }
}
