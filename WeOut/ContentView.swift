//
//  ContentView.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/25/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "doc.text.magnifyingglass")
                    }
                TripsView()
                    .tabItem { Label("Trips", systemImage: "suitcase.rolling.fill") }
                ItineraryView()
                    .tabItem { Label("Itinerary", systemImage: "map.fill") }
            }
            .onAppear() {
                //Set the background color for the tab bar
                //UITabBar.appearance().backgroundColor = UIColor(hex: "#161616")
                // Set the color for the unselected tabs
                UITabBar.appearance().unselectedItemTintColor = .lightGray
            }
            .tint(Color.blue) //Set the color of the selected tabbar item
        }
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
             ContentView().preferredColorScheme($0)
        }
    }
}*/

#Preview {
    ContentView().preferredColorScheme(.dark)
}
