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
        VStack {
            MapView(locations: trip.locations)
                .frame(height: 250)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Places to Visit")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Fri, Feb 16, 2024 - Thur, Feb 29, 2024")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .padding()
                
                MapLocationListView(trip.locations)
                    .listStyle(.plain)
                
                Button {
                    openMap()
                } label: {
                    Label("Directions", systemImage: "arrow.triangle.turn.up.right.diamond")
                }
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()

            }
        }
        .navigationTitle(trip.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton().buttonStyle(.plain)
        }
    }
    
    func openMap() {
        MKMapItem.openMaps(
            with: [MKMapItem.forCurrentLocation()] + trip.locations,
            launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

#Preview {
    let mapItems: [MKMapItem] = [
        MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), addressDictionary: ["City": "San Francisco"])),
        MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437), addressDictionary: ["City": "Los Angeles"])),
        MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611), addressDictionary: ["City": "San Diego"]))
    ]
    
    return NavigationStack {
        NavigationStack {
            TripDetailView(trip: Trip(title: "California Trip", locations: mapItems))
        }
    }
}
