//
//  LocationListView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/16/24.
//

import SwiftUI

struct Location: Identifiable {
    let name: String
    let capital: String
    let country: String
    let image: String
    let id = UUID()
}

struct LocationListView: View {
    @State private var textSearch = ""
    @State private var locations = [
        Location(name: "Tokyo Tower", capital: "Tokyo", country: "🇯🇵 Japan", image: "tokyo"),
        Location(name: "Tower Bridge", capital: "London", country: "🇬🇧 United Kingdom", image: "london"),
        Location(name: "Grand Palace and Wat Prakeaw", capital: "Bangkok",  country: "🇹🇭 Thailand", image: "thailand"),
        Location(name: "Colosseum", capital: "Rome", country: "🇮🇹 Italy", image: "italy"),
        Location(name: "Eiffel Tower", capital: "Paris", country: "🇫🇷 France", image: "france"),
        Location(name: "Sydney Opera House", capital: "Canberra", country: "🇦🇺 Australia", image: "australia"),
        Location(name: "Christ the Redeemer", capital: "Brasília", country: "🇧🇷 Brazil", image: "brazil"),
        Location(name: "Taj Mahal", capital: "New Delhi", country: "🇮🇳 India", image: "india"),
        Location(name: "Niagara Falls", capital: "Ottawa", country: "🇨🇦 Canada", image: "canada"),
        Location(name: "Table Mountain", capital: "Pretoria, Bloemfontein, Cape Town", country: "🇿🇦 South Africa", image: "south-africa"),
        Location(name: "Sagrada Família", capital: "Madrid", country: "🇪🇸 Spain", image: "spain")
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(locations) { location in
                    NavigationLink {
                        Text("Detail")
                    } label: {
                        LocationListRowView(location: location)
                            .padding(.bottom, 18)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle("Popular Destinations")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $textSearch, prompt: "Search destinations...")
    }
}

#Preview {
    LocationListView()
}
