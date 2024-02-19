//
//  HomeView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/8/24.
//

import SwiftUI
import MapKit

struct Guide: Identifiable {
    let title: String
    let date: String
    let image: String
    let id = UUID()
}

struct HomeView: View {
    @State private var textSearch = ""
    @State private var locations = [
        Location(name: "Tokyo Tower", capital: "Tokyo", country: "🇯🇵 Japan", image: "tokyo"),
        Location(name: "Tower Bridge", capital: "London", country: "🇬🇧 United Kingdom", image: "london"),
        Location(name: "Grand Palace and Wat Prakeaw", capital: "Bangkok",  country: "🇹🇭 Thailand", image: "thailand"),
        Location(name: "Colosseum", capital: "Rome", country: "🇮🇹 Italy", image: "italy"),
    ]
    @State private var guides = [
        Guide(title: "Hidden Gems: Uncovering Secret Destinations", date: "Dec 05, 2023", image: "hiking"),
        Guide(title: "Packing Hacks: Travel Light, Travel Smart", date: "Dec 06, 2023", image: "packing"),
        Guide(title: "Travel Tips for Beginners", date: "Jan 2, 2024", image: "boat")
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Section {
                    HStack {
                        Text("Popular Destinations")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        NavigationLink {
                            LocationListView()
                        } label: {
                            HStack {
                                Text("View All")
                                Image(systemName: "arrow.right")
                            }
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .firstTextBaseline, spacing: 18) {
                            ForEach(locations) { location in
                                VStack(alignment: .leading, spacing: 15) {
                                    Image(location.image)
                                        .resizable()
                                        .frame(width: 200, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("\(location.name), \(location.capital)")
                                            .font(.headline)
                                            .lineLimit(1)
                                        
                                        Text("\(location.country)")
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .frame(width: 200)
                            }
                        }
                    }
                }

                Section {
                    HStack {
                        Text("Popular Guides")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        NavigationLink {
                            LocationListView()
                        } label: {
                            HStack {
                                Text("View All")
                                Image(systemName: "arrow.right")
                            }
                        }
                    }
                    .padding(.top, 30)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .firstTextBaseline, spacing: 18) {
                            ForEach(guides) { guide in
                                VStack(alignment: .leading, spacing: 15) {
                                    Image(guide.image)
                                        .resizable()
                                        .frame(width: 200, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(guide.title)
                                            .font(.headline)
                                            .lineLimit(1)
                                        
                                        Text(guide.date)
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .frame(width: 200)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tripify")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $textSearch)
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
