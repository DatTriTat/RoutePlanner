//
//  NewTripView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/15/24.
//

import SwiftUI
import MapKit

struct NewTripView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isShowing = false
    @State private var startDate = Date()
    @State private var title = ""
    @State private var locations: [MKMapItem] = []
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Trip Title", text: $title)
                }
                
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, in: Date()..., displayedComponents: .date)
                }
                
                Section(header: Text("Places to Visit")) {
                    List(locations, id: \.self) { mapItem in
                        Text(mapItem.name ?? "Unknown Location")
                    }
                    
                    Button(action: {
                        isShowing.toggle()
                    }) {
                        Label("Add Stop", systemImage: "plus.circle.fill")
                    }
                    .sheet(isPresented: $isShowing) {
                        SearchMapsView(isShowing: $isShowing) { location in
                            locations.append(location)
                        }
                    }
                }
            }
            .navigationTitle("A New Trip")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let locationObjects = convertMapItemsToLocations(mapItems: locations)
                        let newTrip = Trip(title: title, startDate: startDate, locations: locationObjects)
                        viewModel.addTrip(trip: newTrip)
                        dismiss()
                    }
                    .disabled(title.isEmpty || locations.isEmpty)
                }
            }
        }
    }
}

