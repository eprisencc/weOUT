//
//  WeOutApp.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/25/24.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct WeOutApp: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var myTrips = Trips()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(myTrips)
            
        }
    }
}
