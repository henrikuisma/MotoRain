//
//  SearchBar.swift
//  MotoRain
//
//  Created by Henri Kuisma on 28.3.2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text("Where to?")
                .frame(width: UIScreen.main.bounds.width * 0.75)
                .padding()
                .background(Color.white.opacity(0.9))
                .foregroundColor(.black)
                .cornerRadius(8)
                .shadow(radius: 6)

        }
        
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
