//
//  LocationListRowView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/16/24.
//

import SwiftUI

struct LocationListRowView: View {
    let location: Location
    var body: some View {
        HStack(spacing: 15) {
            Image(location.image)
                .resizable()
                .frame(width: 110, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            
            VStack(alignment: .leading) {
                Text("\(location.name), \(location.capital)")
                    .font(.headline)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)

                Text("\(location.country)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            Spacer()
            Label("See details", systemImage: "chevron.right")
                .labelStyle(.iconOnly)
        }
    }
}

#Preview {
    LocationListRowView(location: Location(name: "Tokyo Tower", capital: "Tokyo", country: "🇯🇵 Japan", image: "tokyo"))
}
