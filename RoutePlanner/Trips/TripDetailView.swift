//
//  TripDetailView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/16/24.
//

import SwiftUI
import MapKit

struct TripDetailView: View {
    @State var trip: Trip
    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                Text(trip.title)
            }
            
            Section(header: Text("Locations")) {
                List {
                    ForEach(trip.locations, id: \.self) { mapItem in
                        if let name = mapItem.name {
                            Text(name)
                        }
                    }
                    .onDelete { indexSet in
                        trip.locations.remove(atOffsets: indexSet)
                    }
                    .onMove { indices, newOffset in
                        trip.locations.move(fromOffsets: indices, toOffset: newOffset)
                    }
                }
            }
            
            HStack {
                Spacer()
                Button {
                    openMap()
                } label: {
                    VStack(spacing: 8) {
                        Label("Directions", systemImage: "arrow.triangle.turn.up.right.diamond").labelStyle(.iconOnly)
                        Text("Direction")
                    }
                }
                Spacer()
            }
        }
        .navigationTitle("Trip Detail")
        .toolbar { EditButton() }
    }
    
    func openMap() {
        MKMapItem.openMaps(
            with: [MKMapItem.forCurrentLocation()] + trip.locations,
            launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

#Preview {
    let empireStateBuildingMapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.748817, longitude: -73.985428)))
    empireStateBuildingMapItem.name = "Empire State Building"
    
    return NavigationStack {
        TripDetailView(trip: Trip(title: "Test", locations: [empireStateBuildingMapItem]))
    }
}
