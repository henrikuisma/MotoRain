//
//  LocationSearchViewModel.swift
//  MotoRain
//
//  Created by Henri Kuisma on 29.3.2025.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocationCoordinate: CLLocationCoordinate2D?
    @Published var shouldCenterUser = false
    @Published var selectedTitle: String?
    @Published var selectedSubtitle: String?

    private let searchCompleter = MKLocalSearchCompleter()

    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
        
    }
    
    func selectLocation(_ LocalSearch: MKLocalSearchCompletion) {
        self.selectedTitle = LocalSearch.title
        self.selectedSubtitle = LocalSearch.subtitle

        locationSearch(forLocalSearchCompletion: LocalSearch) { response, error in
            if let error = error {
                print("Error searching: \(error.localizedDescription)")
                return
            }
            guard let item = response?.mapItems.first else {
                print("No results found")
                return
            }
            let coordinate = item.location.coordinate
            print("Selected location coordinate: \(coordinate)")
            self.selectedLocationCoordinate = coordinate
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.results = completer.results
        }
    }
}

