//
//  WeOutApp.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/25/24.
//

import SwiftUI

@main
struct WeOutApp: App {
    @StateObject var createItinerary = CreateItineraryVM()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(createItinerary)
        }
    }
}
