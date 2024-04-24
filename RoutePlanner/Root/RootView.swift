//
//  RootView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/15/24.
//

import SwiftUI

struct RootView: View {
    var viewModel = ViewModel()
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            
            TripsView()
                .tabItem { Label("Trips", systemImage: "mappin.and.ellipse") }
                .environmentObject(viewModel)  // Pass the ViewModel instance to the views

            NotificationsView()
                .tabItem { Label("Notifications", systemImage: "bell") }
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
    }
}

#Preview {
    RootView()
}
