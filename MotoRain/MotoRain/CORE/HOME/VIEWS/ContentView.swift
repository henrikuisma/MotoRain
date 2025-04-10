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
    @State private var mapState = MapViewState.noInput
    
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            MapViewRepresentable(mapState: $mapState)
                .ignoresSafeArea()
            
            
            VStack {
                Spacer()
                if mapState == .searchingForLocation {
                    LocationSearchView(mapState: $mapState)
                } else if mapState == .noInput {
                    SearchBar(text: $searchText)
                        .padding(.bottom, 75)
                        .padding(.leading, 35)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapState = .searchingForLocation

                        }
                    }
                }
            }
            VStack {
                HStack{
                    ActionButton(mapState: $mapState)
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
