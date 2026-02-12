//
//  ContentView.swift
//  MotoRain
//
//  Created by Henri Kuisma on 26.3.2025.

import SwiftUI
import MapKit

struct ContentView: View {

    @State private var searchText = ""
    @State private var mapState = MapViewState.noInput

    @State private var selectedDetent: PresentationDetent = .fraction(0.55)

    @EnvironmentObject private var locationViewModel: LocationSearchViewModel

    var body: some View {

        ZStack(alignment: .topLeading) {

            // MARK: Map
            MapViewRepresentable(mapState: $mapState)
                .ignoresSafeArea()

            // MARK: Location search view
            VStack {
                HStack {
                    if mapState == .searchingForLocation {
                        LocationSearchView(mapState: $mapState)
                            .padding(.top, 10)
                    }
                }
            }

            // MARK: Action button
            VStack {
                HStack {
                    ActionButton(mapState: $mapState)
                        .padding(.leading)
                        .padding(.top, 40)

                    Spacer()
                }
            }

            // MARK: Bottom search bar
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

        .sheet(
            isPresented: Binding<Bool>(
                get: { mapState == .locationSelected },
                set: { presented in
                    if !presented {
                        mapState = .noInput
                    }
                }
            )
        ) {
            DestinationView(
                isCollapsed: selectedDetent == .fraction(0.22)
            )
            .environmentObject(locationViewModel)
            .presentationDetents(
                [.height(110), .fraction(0.44)],
                selection: $selectedDetent
            )
            .presentationDragIndicator(.visible)
            .presentationBackground(.clear)
            .presentationBackgroundInteraction(.enabled)
            .presentationCornerRadius(40)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationSearchViewModel())
}
