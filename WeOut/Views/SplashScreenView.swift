//
//  SplashScreenView.swift
//  WeOut
//
//  Created by Jonathan Loving on 6/10/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @AppStorage("showMainApp") private var showMainApp = false
    @State private var size = 0.2
    @State private var opacity = 0.5
    
    @StateObject var myTrips = Trips()
    // 1. Add StateObject authManager.
    @StateObject var authManager: AuthManager = AuthManager()
    @StateObject var profileVm: ProfileViewModel = ProfileViewModel()
    @StateObject private var planVm: PlansViewModel = PlansViewModel()
    
    var body: some View {
        if isActive {
            if showMainApp {
                ContentView()
                    .environmentObject(myTrips)
                    // 3. Pass authManager to enviromentObject.
                    .environmentObject(authManager)
                    .environmentObject(profileVm)
                    .environmentObject(planVm)
            }
            else {
                ActualOnboardingView(showMainApp: $showMainApp)
            }
        }
        else {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        Image("weOutLogo_wText")
                            .resizable()
                            .frame(width: 200, height: 200)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 1.0
                            self.opacity = 1.0
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
