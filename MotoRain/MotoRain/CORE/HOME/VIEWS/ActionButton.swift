//
//  ActionButton.swift
//  MotoRain
//
//  Created by Henri Kuisma on 29.3.2025.
//

import SwiftUI

struct ActionButton: View {
    @Binding var mapState: MapViewState
    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameforState(mapState))
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(radius: 6)
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
            print("Clear map view...")
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
