//
//  ContentView.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/25/24.
//

import SwiftUI
import Firebase

struct ContentView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground() // <- HERE
        appearance.backgroundImage = UIImage(named: "sandBottomTab")
        appearance.stackedLayoutAppearance.normal.iconColor = .black
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.blue)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.blue)]
        
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        ZStack() {
            TabView {
                TripsView {
                    
                }
                    .tabItem { Label("Trips", systemImage: "suitcase.rolling.fill") }
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "doc.text.magnifyingglass")
                    }
            }
        }
    }
}

#Preview {
    ContentView().preferredColorScheme(.dark)
        .environmentObject(Trips())
}
