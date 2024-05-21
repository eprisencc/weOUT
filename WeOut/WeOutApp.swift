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
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
    }
    
    @StateObject var myTrips = Trips()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(myTrips)
            
        }
    }
}
