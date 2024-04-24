//
//  RoutePlannerApp.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/8/24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct RoutePlannerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var viewModel = ViewModel() 
    init() {
            NetworkMonitor.shared.startMonitoring()
        }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if viewModel.isAuthenticated && (viewModel.user != nil)  {
                    RootView()
                } else {
                    LoginView(viewmodel: viewModel)
                }				            }
            .environmentObject(viewModel)
            .onAppear {
            }
        }
    }
}
