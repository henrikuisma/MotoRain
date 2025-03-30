//
//  ContentView.swift
//  MotoRain
//
//  Created by Henri Kuisma on 26.3.2025.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var isUserCentered = false
    @State private var is3D = false
    @State private var searchText = ""
    @State private var showLocationSearchView = false
    
    let mapView = MotoRainMapViewRepresentable()
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            MotoRainMapViewRepresentable()
                .ignoresSafeArea()
            
            
            VStack {
                Spacer()
                if showLocationSearchView {
                    LocationSearchView()
                } else {
                    SearchBar(text: $searchText)
                        .padding(.bottom, 75)
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
            }
        }
        .ignoresSafeArea()
        
    }
}


#Preview {
    ContentView()
}
