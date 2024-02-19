//
//  NewTripFormView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/15/24.
//

import SwiftUI
import MapKit

struct NewTripFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isShowing = false
    @State private var title = ""
    @State private var locations: [MKMapItem] = []
    var addNewTrip: (Trip) -> ()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("New York Trip", text: $title)
                }
                
                Section(header: Text("Locations")) {
                    List {
                        ForEach(locations, id: \.self) { mapItem in
                            if let name = mapItem.name {
                                Text(name)
                            }
                        }
                    }
                    
                    Button {
                        isShowing.toggle()
                    } label: {
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
                        addNewTrip(Trip(title: title, locations: locations))
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NewTripFormView() { newTrip in }
}
