import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
@main
struct RoutePlannerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var viewModel = ViewModel()
    @Environment(\.scenePhase) var scenePhase
    @State private var isAuthenticating = false

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .active:
                        if !isAuthenticating && viewModel.isAuthenticated {
                            isAuthenticating = true
                            viewModel.authenticateBiometrically { success, error in
                                if !success {
                                    viewModel.signOut()
                                } else {
                                    isAuthenticating = true
                                }
                            }
                        }
                    case .inactive, .background:
                        break
                    @unknown default:
                        break
                    }
                }
        }
    }
}

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.isAuthenticated {
                RootView()
            } else {
                LoginView(viewmodel: viewModel)
            }
        }
    }
}

