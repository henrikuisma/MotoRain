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
        GeometryReader { proxy in
            let width = proxy.size.width * 0.75
            
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                Text("Search")
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(width: width, alignment: .center)
            .glassEffect(
                .regular.tint(.black.opacity(0.1)),
                in: .rect(cornerRadius: 12, style: .continuous)
            )
            .shadow(color: Color.black.opacity(0.02), radius: 8, y: 2)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.top, 0)
        }
        .frame(height: 48)
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
