# MotoRain 💧🏍️

MotoRain is an iOS proof of concept for motorcycle route planning that aims to work like familiar apps (Apple Maps, Google Maps, etc.) but with a twist: it will highlight and suggest routes that avoid rainy areas.

⚠️ Status: Early prototype, not a working app. Features, UI, and data sources are incomplete and may change.

## What it does now
- SwiftUI wrapper around `MKMapView` (MapKit)
- Shows user location and compass
- Lets you select a destination
- Draws a route polyline from your current location

## Goal
- Full route planning experience with weather awareness
- Visualize rain along the route and suggest drier alternatives for riders
- Explore Apple Intelligence to suggest helpful stops (e.g., gas stations, cafes, shelters) when avoiding rain isn’t possible—so riders can safely wait it out

## Tech
- Swift, SwiftUI + `UIViewRepresentable`
- MapKit (`MKMapView`, `MKDirections`)
- Coordinator pattern for map delegate handling

## Getting started
- Xcode 15+, iOS 26+ (adjust as needed)
- Add NSLocationWhenInUseUsageDescription to Info.plist
- Build and run (simulated or real location)

## Contributing
Issues and PRs are welcome—this is a proof of concept and evolving quickly.

## License
TBD
