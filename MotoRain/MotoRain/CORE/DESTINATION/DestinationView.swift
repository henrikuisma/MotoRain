//
//  DestinationView.swift
//  MotoRain
//
//  Created by Henri Kuisma on 7.2.2026.
//

import SwiftUI
import CoreLocation
import MapKit

struct LookAroundViewControllerRepresentable: UIViewControllerRepresentable {
    let scene: MKLookAroundScene
    
    func makeUIViewController(context: Context) -> MKLookAroundViewController {
        let controller = MKLookAroundViewController()
        controller.scene = scene
        controller.pointOfInterestFilter = .includingAll
        controller.showsRoadLabels = true
        return controller
    }
    
    func updateUIViewController(_ uiViewController: MKLookAroundViewController, context: Context) {
    }
}

struct DestinationView: View {
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @StateObject private var locationManager = LocationManager()
    
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isLoadingScene = false
    @State private var sceneError: Error?
    
    private var coordinateKey: String {
        if let c = locationViewModel.selectedLocationCoordinate {
            return String(format: "%.6f,%.6f", c.latitude, c.longitude)
        } else {
            return "nil"
        }
    }
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
            
            HStack {
                VStack{
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 32)
                    
                    Circle()
                        .fill(.black)
                        .frame(width: 8, height: 8)
                }
                
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(locationManager.address)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        
                        Spacer()
                        
                        Text("--:--")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            let title = locationViewModel.selectedTitle ?? "No destination selected"
                            let subtitle = locationViewModel.selectedSubtitle ?? ""
                            Text(subtitle.isEmpty ? title : "\(title), \(subtitle)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        
                        Spacer()
                        
                        Text("--:--")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }

                }
                .padding(.leading, 8)
            }
            .padding()
            
            Divider()
            
            lookAroundCard()
                .padding(.horizontal)
                .padding(.bottom, 12)
        }
        .onChange(of: coordinateKey) { _, _ in
            loadLookAroundScene(for: locationViewModel.selectedLocationCoordinate)
        }
        .task {
            loadLookAroundScene(for: locationViewModel.selectedLocationCoordinate)
        }
    }
    
    @ViewBuilder
    private func lookAroundCard() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Look Around")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
            
            ZStack {
                if isLoadingScene {
                    Color(.secondarySystemBackground)
                    ProgressView()
                } else if let scene = lookAroundScene {
                    LookAroundViewControllerRepresentable(scene: scene)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                } else if let _ = sceneError {
                    Color(.secondarySystemBackground)
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.orange)
                        Text("Look Around is not available for this location.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Color(.secondarySystemBackground)
                    VStack(spacing: 8) {
                        Image(systemName: "mappin.slash")
                            .foregroundColor(.secondary)
                        Text("Select a destination to see Look Around.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.black.opacity(0.05), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.06), radius: 12, y: 6)
        }
    }
    
    private func loadLookAroundScene(for coordinate: CLLocationCoordinate2D?) {
        lookAroundScene = nil
        sceneError = nil
        
        guard let coordinate else { return }
        isLoadingScene = true
        
        let request = MKLookAroundSceneRequest(coordinate: coordinate)
        Task {
            do {
                let scene = try await request.scene
                await MainActor.run {
                    self.lookAroundScene = scene
                    self.isLoadingScene = false
                }
            } catch {
                await MainActor.run {
                    self.sceneError = error
                    self.isLoadingScene = false
                }
            }
        }
    }
}

#Preview {
    DestinationView()
        .environmentObject(LocationSearchViewModel())
}

