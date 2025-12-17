# MotoRain 💧🏍️

**Work in progress 🚧**

MotoRain is a route-planning app for motorcyclists. The goal is to display routes like Google Maps, but taking into account rainy areas and weather conditions.

## Current Status
- Modular project structure with cleaned-up files.
- `ContentView` with `LocationSearch`, `SearchBar`, `ActionButton`, and dynamic search results.
- MapKit integration showing user location and destination routes via `MKPolyline`.
- `MotoRainMapViewRepresentable` with smooth UI transitions (`MapViewState`) and zoom adjusted for user and destination.
- `LocationManager` handles automatic address fetching; markers placed on selection.

## Goals
- Integrate weather data and rain-avoidance routing.
- Implement ETA calculation and route optimization.
- Enhance UI and provide full user experience.
