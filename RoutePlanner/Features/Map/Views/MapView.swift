//
//  MapView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/21/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    let locations: [MKMapItem]
    var body: some View {
        Map {
            ForEach(locations.indices, id: \.self) { index in
                Marker(
                    locations[index].name ?? "Unknown",
                    systemImage: "\(index + 1).circle",
                    coordinate: locations[index].placemark.coordinate
                )
            }
        }
    }
}
