//
//  TripsView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/15/24.
//

import SwiftUI
import MapKit

struct Trip: Identifiable {
    var title: String
    var locations: [MKMapItem]
    let id = UUID()
}

struct TripsView: View {
    @State var trips: [Trip] = []
    
    var body: some View {
        NavigationStack {
            List(trips) { trip in
                NavigationLink(trip.title) {
                    TripDetailView(trip: trip)
                }
            }
            .navigationTitle("Trip Plans")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("New Trip") {
                        NewTripView() { newTrip in
                            trips.append(newTrip)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TripsView()
}
