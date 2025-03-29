//
//  ContentView.swift
//  MotoRain
//
//  Created by Henri Kuisma on 26.3.2025.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject private var mapManager = MapManager()
    @State private var searchText = ""
    
    var body: some View {
        
        Map(position: $mapManager.position) {
            
        }
        .mapControls{
            MapUserLocationButton()
            MapPitchToggle()
        }
        
        .overlay(
            VStack {
                Spacer()
                SearchBar(text: $searchText)
                    .padding(.bottom, 40)
            }
        )
        .onAppear {
            mapManager.updatePosition()
        }
    }
}

#Preview {
    ContentView()
}
