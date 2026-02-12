//
//  DestinationView.swift
//  MotoRain
//
//  Created by Henri Kuisma on 7.2.2026.
//

import SwiftUI
import CoreLocation
import MapKit

// MARK: - LookAround UIView wrapper

struct LookAroundViewControllerRepresentable: UIViewControllerRepresentable {

    let scene: MKLookAroundScene

    func makeUIViewController(context: Context) -> MKLookAroundViewController {
        let controller = MKLookAroundViewController()
        controller.scene = scene
        controller.pointOfInterestFilter = .includingAll
        controller.showsRoadLabels = true
        return controller
    }

    func updateUIViewController(
        _ uiViewController: MKLookAroundViewController,
        context: Context
    ) {}
}

// MARK: - DestinationView

struct DestinationView: View {

    let isCollapsed: Bool

    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @StateObject private var locationManager = LocationManager()

    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isLoadingScene = false
    @State private var sceneError: Error?

    // SwiftUI onChange workaround
    private var coordinateKey: String {
        guard let c = locationViewModel.selectedLocationCoordinate else {
            return "nil"
        }
        return "\(c.latitude),\(c.longitude)"
    }

    private let sheetCornerRadius: CGFloat = 24

    // MARK: - Body

    var body: some View {

        Group {
            if isCollapsed {
                collapsedView
            } else {
                expandedView
            }
        }
        .onChange(of: coordinateKey) { _, _ in
            loadLookAroundScene(for: locationViewModel.selectedLocationCoordinate)
        }
        .task {
            loadLookAroundScene(for: locationViewModel.selectedLocationCoordinate)
        }
    }
}

//
// MARK: - Collapsed Layout (Apple Maps style)
//

private extension DestinationView {

    var collapsedView: some View {
        VStack(spacing: 8) {
            routeHeader
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

//
// MARK: - Expanded Layout
//

private extension DestinationView {

    var expandedView: some View {
        ScrollView {
            VStack(spacing: 16) {
                routeHeader
                Divider()
                lookAroundCard()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .scrollIndicators(.hidden)
    }
}

//
// MARK: - Route Header (origin + destination + ETA)
//

private extension DestinationView {

    var routeHeader: some View {
        HStack(alignment: .top, spacing: 12) {

            timelineColumn()

            VStack(alignment: .leading, spacing: 24) {

                // Origin
                HStack {
                    Text(locationManager.address)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                        .lineLimit(1)

                    Spacer()

                    Text("--:--") // TODO: origin ETA
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                }

                // Destination
                HStack {
                    let title = locationViewModel.selectedTitle ?? "No destination selected"
                    let subtitle = locationViewModel.selectedSubtitle ?? ""

                    Text(subtitle.isEmpty ? title : "\(title), \(subtitle)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    Spacer()

                    Text("--:--") // TODO: destination ETA
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 12)
    }

    func timelineColumn() -> some View {
        VStack(spacing: 0) {
            Circle()
                .fill(Color(.systemGray3))
                .frame(width: 8, height: 8)

            Rectangle()
                .fill(Color(.systemGray3))
                .frame(width: 1, height: 24)
                .padding(.vertical, 7)

            Circle()
                .fill(.black)
                .frame(width: 8, height: 8)
        }
        .padding(.vertical, 4)
    }
    
}

//
// MARK: - LookAround Card (expanded only)
//

private extension DestinationView {

    @ViewBuilder
    func lookAroundCard() -> some View {
        ZStack {

            if isLoadingScene {
                Color(.secondarySystemBackground)
                ProgressView()

            } else if let scene = lookAroundScene {
                LookAroundViewControllerRepresentable(scene: scene)

            } else if sceneError != nil {
                placeholderView(
                    icon: "exclamationmark.triangle",
                    text: "Look Around is not available for this location.",
                    color: .orange
                )

            } else {
                placeholderView(
                    icon: "mappin.slash",
                    text: "Select a destination to see Look Around.",
                    color: .secondary
                )
            }
        }
        .frame(height: 220)
        .clipShape(
            RoundedRectangle(
                cornerRadius: sheetCornerRadius,
                style: .continuous
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: sheetCornerRadius)
                .stroke(Color.black.opacity(0.05), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    func placeholderView(icon: String, text: String, color: Color) -> some View {
        Color(.secondarySystemBackground)
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: icon)
                        .foregroundColor(color)

                    Text(text)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            )
    }
}

//
// MARK: - LookAround loader
//

private extension DestinationView {

    func loadLookAroundScene(for coordinate: CLLocationCoordinate2D?) {
        lookAroundScene = nil
        sceneError = nil

        guard let coordinate else { return }
        isLoadingScene = true

        let request = MKLookAroundSceneRequest(coordinate: coordinate)

        Task {
            do {
                let scene = try await request.scene
                await MainActor.run {
                    lookAroundScene = scene
                    isLoadingScene = false
                }
            } catch {
                await MainActor.run {
                    sceneError = error
                    isLoadingScene = false
                }
            }
        }
    }
}

#Preview("Expanded") {
    DestinationView(isCollapsed: false)
        .environmentObject(LocationSearchViewModel())
}

#Preview("Collapsed") {
    DestinationView(isCollapsed: true)
        .environmentObject(LocationSearchViewModel())
}
