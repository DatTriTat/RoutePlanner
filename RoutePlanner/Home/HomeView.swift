//
//  HomeView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/8/24.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @State private var mapItems: [MKMapItem]?
    @State private var mapItem: MKMapItem?

    var body: some View {
        Text("Home View")
    }
}

#Preview {
    HomeView()
}
