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
    
    @EnvironmentObject private var locationViewModel: LocationSearchViewModel
    
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
            
            VStack {
                Spacer()
                if mapState == .locationSelected {
                    DestinationView()
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.15), radius: 12, y: -2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: mapState)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
    }
}


#Preview {
    ContentView()
        .environmentObject(LocationSearchViewModel())
}
