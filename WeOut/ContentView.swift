//
//  ContentView.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/25/24.
//

import SwiftUI

struct ContentView: View {
    
    //Add an image to the background of TabView
    //    init() {
    //        let appearance = UITabBarAppearance()
    //        appearance.configureWithOpaqueBackground()
    //        appearance.backgroundImage = UIImage(named: "sandBottom")
    //        UITabBar.appearance().scrollEdgeAppearance = appearance
    //    }
    
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
        ZStack(/*alignment: .bottom*/) {
            //Color.black
            //.ignoresSafeArea()
            //            Image("cloudBack")
            //                .resizable()
            //                .ignoresSafeArea(/*edges: .top*/)
            TabView {
                TripsView()
                    .tabItem { Label("Trips", systemImage: "suitcase.rolling.fill") }
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "doc.text.magnifyingglass")
                    }
                /*ItineraryView()
                 .tabItem { Label("Itinerary", systemImage: "map.fill") }*/
            }
            //.onAppear() {
                //Set the background color for the tab bar
                //UITabBar.appearance().backgroundColor = UIColor.tabbarBlue//(hex: "#21528A")
                // Set the color for the unselected tabs
                //                UITabBar.appearance().unselectedItemTintColor = UIColor.black
                //UITabBar.appearance().scrollEdgeAppearance
            //}
            
//            Image("sandBottom")
//                .resizable()
//                .scaledToFit()
            //            .tint(Color.blue) //Set the color of the selected tabbar item
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
        .environmentObject(CreateItineraryVM())
        .environmentObject(CreateTripVM())
}
