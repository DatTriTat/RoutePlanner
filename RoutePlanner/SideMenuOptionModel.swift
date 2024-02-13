//
//  SideMenuOptionModel.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/10/24.
//

import Foundation

enum SideMenuOptionModel: Int, CaseIterable {
    case home
    case trips
    case notifications
    case settings
    
    var title: String {
        switch self {
        case .home:
            "Home"
        case .trips:
            "Trips"
        case .notifications:
            "Notifications"
        case .settings:
            "Settings"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .home:
            "house"
        case .trips:
            "road.lanes"
        case .notifications:
            "bell"
        case .settings:
            "gearshape"
        }
    }
}

extension SideMenuOptionModel: Identifiable {
    var id: Int { rawValue }
}
