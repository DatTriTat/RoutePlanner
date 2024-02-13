//
//  RoutePlannerView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/8/24.
//

import SwiftUI

struct RoutePlannerView: View {
    @State private var showingSideMenu = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Route Planner")
                }
                SideMenuView(isShowing: $showingSideMenu)
            }
            .toolbar(showingSideMenu ? .hidden : .visible, for: .navigationBar)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showingSideMenu.toggle()
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                    })
                }
            }
        }
    }
}

#Preview {
    RoutePlannerView()
}
