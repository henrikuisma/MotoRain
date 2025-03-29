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
            TextField("Where to?", text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .shadow(radius: 6)
                .overlay(
                    HStack {
                        Spacer()
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 25)
                            }
                        }
                    }
                )
                
        }
        
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
