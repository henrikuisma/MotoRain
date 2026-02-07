//
//  ActionButton.swift
//  MotoRain
//
//  Created by Henri Kuisma on 29.3.2025.
//

import SwiftUI

struct ActionButton: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameforState(mapState))
                .font(.title2)
                .foregroundStyle(.black)
                .padding(14)
                .glassEffect(
                    .regular.tint(.black.opacity(0.1)),
                    in: .circle
                )
                .shadow(color: Color.black.opacity(0.02), radius: 8, y: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func actionForState(_ state: MapViewState) {
        switch state {
        case .noInput:
            print("No input")
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected:
            mapState = .noInput
            viewModel.selectedLocationCoordinate = nil
        }
    }
    
    func imageNameforState(_ state: MapViewState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation, .locationSelected:
            return "arrow.left"
        }
    }
}

#Preview {
    ActionButton(mapState:
            .constant(.noInput))
}

