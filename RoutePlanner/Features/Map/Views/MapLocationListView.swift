//
//  MapLocationListView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/21/24.
//

import SwiftUI
import MapKit

struct MapLocationListView: View {
    let locations: [MKMapItem]
    
    init(_ locations: [MKMapItem]) {
        self.locations = locations
    }
    
    var body: some View {
        List {
            ForEach(locations.indices, id: \.self) { index in
                if let name = locations[index].name {
                    HStack(alignment: .top) {
                        VStack(spacing: 0) {
                            Image(systemName: "\(index + 1).circle")
                                .font(.title2)
                            Rectangle()
                                .frame(width: 2, height: 30)
                                .foregroundStyle(.gray)
                        }
                        
                        Text(name).fontWeight(.semibold)
                    }
                    .frame(height: 40)
                }
            }
        }
    }
}
