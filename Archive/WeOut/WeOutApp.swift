//
//  WeOutApp.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/25/24.
//

import SwiftUI
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
}
  

@main
struct WeOutApp: App {
    @StateObject var myTrips = Trips()
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // 1. Add StateObject authManager.
    @StateObject var authManager: AuthManager = AuthManager()
    @StateObject var profileVm: ProfileViewModel = ProfileViewModel()
    
    init() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
    }
    
    // 2. Initialize authManager.
            /*let authManager = AuthManager()
            _authManager = StateObject(wrappedValue: authManager)*/
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(myTrips)
                // 3. Pass authManager to enviromentObject.
                .environmentObject(authManager)
                .environmentObject(profileVm)

            
        }
    }
}
