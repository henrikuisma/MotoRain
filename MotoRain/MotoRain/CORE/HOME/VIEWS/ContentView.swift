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
                HStack {
                    if mapState == .searchingForLocation {
                        LocationSearchView(mapState: $mapState)
                            .padding(.top, 10)
                    }
                }
            }
            VStack {
                HStack{
                    ActionButton(mapState: $mapState)
                        .padding(.leading)
                        .padding(.top, 40)
                    Spacer()
                }
            }
            VStack {
                Spacer()
                
                if mapState == .noInput {
                    HStack {
                        Spacer()
                        SearchBar(text: $searchText)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    mapState = .searchingForLocation
                                }
                            }
                        Spacer()
                    }
                    .padding(.bottom, 70)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
    }
}


#Preview {
    ContentView()
        .environmentObject(LocationSearchViewModel())
}
