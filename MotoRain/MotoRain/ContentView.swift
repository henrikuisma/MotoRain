//
//  ContentView.swift
//  MotoRain
//
//  Created by Henri Kuisma on 26.3.2025.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    var body: some View {
        Map(position: $position) {
            
        }
        .mapControls{
            MapUserLocationButton()
            MapPitchToggle()
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
}

#Preview {
    ContentView()
}
