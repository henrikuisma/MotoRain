//
//  ActionButton.swift
//  MotoRain
//
//  Created by Henri Kuisma on 29.3.2025.
//

import SwiftUI

struct ActionButton: View {
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: "line.3.horizontal")
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ActionButton()
}
