//
//  ActualOnboardingView.swift
//  WeOut
//
//  Created by Jonathan Loving on 6/13/24.
//

import SwiftUI

struct ActualOnboardingView: View {
    @Binding var showMainApp: Bool
    
    var body: some View {
        ZStack {
            Image("OB_cloudBack")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                TabView {
                    OnboardingView(title: "Create a trip", image: "splash_trip", description: "To initiate a new trip, please select the plus icon.")
                    OnboardingView(title: "Details", image: "splash_detail_01", description: "Please input comprehensive details including location, timing, and visual representation.")
                    OnboardingView(title: "Generate itinerary", image: "splash_itin", description: "After the trip has been created, you may proceed to select it in order to generate an itinerary, where then you'll input the trip details.")
                }
                .tabViewStyle(PageTabViewStyle())
                //.foregroundStyle(.black)
                .padding()
                
                //Spacer()
                
                Button("Get Started") {
                    showMainApp.toggle()
                }
                .padding()
                .font(.title3)
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(10)
                .padding(.bottom, 50)
            }
        }
    }
}

/*#Preview {
    ActualOnboardingView(showMainApp: <#T##Binding<Bool>#>)
}*/
