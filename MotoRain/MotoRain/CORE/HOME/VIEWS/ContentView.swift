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
    @State private var showLocationSearchView = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(position: $mapManager.position)
                .mapControls {
                    MapUserLocationButton()
                    MapPitchToggle()
                }
                .padding(.top, 50)
                

            VStack {
                Spacer()
            
                if showLocationSearchView {
                    LocationSearchView()
                } else {
                    SearchBar(text: $searchText)
                        .padding(.bottom, 50)
                        .padding(.leading, 35)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showLocationSearchView.toggle()
                            }
                        }
                }
            }
            VStack {
                HStack{
                    ActionButton(showLocationSearchView: $showLocationSearchView)
                        .padding(.leading)
                        .padding(.top, 50)
                    Spacer()
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            mapManager.updatePosition()
        }
    }
}

#Preview {
    ContentView()
}
