//
//  SearchMapsView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/15/24.
//

import SwiftUI
import MapKit

struct SearchMapsView: View {
    @Binding var isShowing: Bool
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var selection: MKMapItem?
    var selectedLocation: (MKMapItem) -> Void
    
    var body: some View {
        NavigationStack {
            List(searchResults, id: \.self, selection: $selection) { mapItem in
                HStack(spacing: 12) {
                    Image(systemName: "mappin.and.ellipse")
                    VStack(alignment: .leading, spacing: 4) {
                        Text(mapItem.name ?? "Unknown")
                        Text(mapItem.placemark.title ?? "Unknown")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                .onTapGesture {
                    selectedLocation(mapItem)
                    isShowing = false
                }
            }
            .navigationTitle("Search Maps")
            .searchable(text: $searchText)
            .onChange(of: searchText) { search() }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { isShowing = false }
                }
            }
        }
    }
    
    func search() {
        guard searchText != "" else {
            searchResults = []
            return
        }
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText

        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            searchResults = response.mapItems
        }
    }
}

#Preview {
    SearchMapsView(isShowing: .constant(true)) { location in }
}
