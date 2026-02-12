//
//  DestinationCardContainer.swift
//  MotoRain
//
//  Created by Henri Kuisma on 12.2.2026.
//

import SwiftUI

struct DestinationCardContainer<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    private let cornerRadius: CGFloat = 38

    var body: some View {

        let shape = RoundedRectangle(
            cornerRadius: cornerRadius,
            style: .continuous
        )

        VStack(spacing: 0) {
            Capsule()
                .fill(.secondary.opacity(0.4))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 8)

            content
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity)
        .background {
            shape
                .fill(.clear)
                .glassEffect(.regular.tint(.white.opacity(0.08)), in: shape)
        }

        .clipShape(shape)

        .overlay {
            shape.stroke(Color.black.opacity(0.05), lineWidth: 0.5)
        }

        .shadow(color: .black.opacity(0.12), radius: 16, y: 8)


        .contentShape(shape)
    }
}
