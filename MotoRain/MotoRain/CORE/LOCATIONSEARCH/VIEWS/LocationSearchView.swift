//
//  LocationSearchView.swift
//  MotoRain
//
//  Created by Henri Kuisma on 29.3.2025.
//

import SwiftUI

struct LocationSearchView: View {
    @ObservedObject var locationManager = LocationManager()
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {
        VStack {
            
            HStack {
                VStack{
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)
                    
                    Circle()
                        .fill(.black)
                        .frame(width: 6, height: 6)
                }
                
                VStack {
                    TextField("current location", text:
                            .constant(locationManager.address))
                    .frame(height: 32)
                    .background(Color(.systemGroupedBackground))
                    .padding(.trailing)
                    
                    TextField("Where to?", text:
                                $viewModel.queryFragment)
                    .frame(height: 32)
                    .background(Color(.systemGray4))
                    .padding(.trailing)
                            
                }
            }
            .padding(.horizontal)
            .padding(.top, 100)
            
            Divider()
                .padding(.vertical)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { result in
                            ResultCell(title: result.title, subtitle: result.subtitle)
                            .onTapGesture {
                                viewModel.selectLocation(result)
                                mapState = .locationSelected
                                
                            }
                    }
                }
            }
        }
        .background(.white)
    }
}

#Preview {
    LocationSearchView(mapState: .constant(.searchingForLocation))
        .environmentObject(LocationSearchViewModel())
        
}
