//
//  ContentView.swift
//  MotoRain
//
//  Created by Henri Kuisma on 26.3.2025.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var searchText = ""
    @State private var showLocationSearchView = false
    
    let mapView = MapViewRepresentable()
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            MapViewRepresentable()
                .ignoresSafeArea()
            
            
            VStack {
                Spacer()
                if showLocationSearchView {
                    LocationSearchView(showLocationSearchView: $showLocationSearchView)
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
        .environmentObject(LocationSearchViewModel())
}
