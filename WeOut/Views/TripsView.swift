//
//  TripsView.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/26/24.
//

import SwiftUI
import Firebase
import Foundation
import FirebaseAuth
import FirebaseCore
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TripsView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showTripsInputSheet = false
    @State private var showEditTripsInputSheet = false
    @State private var showLoginSheet = false
    @State private var showItineraryItems = false
    
    // Trip object with all the trips in it
    @EnvironmentObject var myTrips: Trips
    @EnvironmentObject var profileVm: ProfileViewModel
    
    @FirestoreQuery(collectionPath: "users") var alltrips : [TripModel]
    
    
    @State var myIndex: Int = -1
    @State var currentIndex: Int = 0
    //@State var myTrips: Trips = Trips()
    //var onTap: () -> Void
    
    //Formate Dates for display in trips view
    var formatter1: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "MMM. d"
        return df
    }
    
    var formatter2: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "MMM d, y"
        return df
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                //Color(hex: "#003459")
                Image("cloudSandBack")
                    .resizable()
                    .ignoresSafeArea(/*edges: .top*/)
                //                Image("sandBottom")
                //                    .resizable()
                //                    .scaledToFit()
                
                VStack(alignment: .leading) {
                    HStack {
                        
                        //MARK: display info from FB instead to  ensure u always get a name ~JW
                        if let user = profileVm.currentUser {
                            Text("Hi, " + "\(user.name)")
                                .font(.headline)
                                .foregroundStyle(Color.titleheadings)
                                .padding(.horizontal, 25)
                            
                        }
                        else {
                            Text("Sign-in to view data!")
                                .font(.headline)
                        }
                        
                        
                        
                    }
                    //                    .sheet(isPresented: $showLoginSheet) {
                    //                        LoginView()
                    //                    }
                    tripHeading
                    Spacer()
                    tripDetails
                    
                    // Show `Sign out` iff user is not anonymous,
                    // otherwise show `Sign-in` to present LoginView() when tapped.
                    HStack {
                        Spacer()
                        Button {
                            if authManager.authState != .signedIn {
                                showLoginSheet = true
                            } else {
                                signOut()
                            }
                        } label: {
                            Text(authManager.authState != .signedIn ? "Sign-in" :"Sign out")
                                .font(.body.bold())
                                .frame(width: 150, height: 45, alignment: .center)
                                .foregroundStyle(Color(.white))
                                .background(Color(.blue))
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                    
                }
            }
            .sheet(item: $profileVm.selectedTrip) { trip in
                ItineraryView(trip: trip)
            }
            .sheet(item: $profileVm.editTrip) { trip in
                EditTripsInputSheet(trip: trip)
            }
            
            
            .task{
                try? await profileVm.loadCurrentUser()
                if let user = profileVm.currentUser{
//                    $alltrips.path = "users/\(user.uid)/myTrips"
//                    print("⚡️⚡️⚡️⚡️Path updated for trips: \($alltrips.path)")
                    
                profileVm.showCurrentTrips(userID: user.uid)
                }
                
                //                  profileVm.getMyTrips()
            }//MARK: ~JW
            
            
        }
    }

    var tripHeading: some View {
        HStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 40)
                .clipShape(Circle())
            Text("Trips")
                .font(.largeTitle)
                .foregroundStyle(Color.titleheadings)
                .bold()
            Spacer()
            //Bring up the Trip input sheet
            Button {
                showTripsInputSheet.toggle()
                myTrips.resetTripProperties()
            }
        label:{
            Image(systemName: "plus")
        }
        .sheet(isPresented: $showTripsInputSheet) {
            TripsInputSheet()
                .presentationDetents([.large])
                .background(Color(hex: "1F1F1F").ignoresSafeArea())
        }
        .foregroundStyle(.titleheadings)
        .font(.largeTitle)
        }
        .padding(.horizontal, 25)
    }
    var tripDetails: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Active Trips")
                    .padding(.horizontal, 20)
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(profileVm.myTrips,id: \.id) { trip in
                            if (trip.endDate > Date.now) {
                                NavigationLink {
                                    //profileVm.selectedTrip = trip
                                    ItineraryView(trip: trip)
                                } label: {
                                    ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                                        
                                        // use the link from fb to display an image ~JW
                                        coverPhoto(link: trip.coverPhoto ?? "")
                                        
                                        VStack(alignment: .leading){
                                            HStack {
                                                Text(trip.destination)
                                                    .font(.title)
                                                    .foregroundStyle(Color.white)
                                                    .bold()
                                                Spacer()
                                                
                                                Button() {
                                                    profileVm.editTrip = trip
                                                } label: {
                                                    Image(systemName: "ellipsis")
                                                }
                                                .font(.largeTitle)
                                            }
                                            .foregroundStyle(.white)
                                            .padding(10)
                                            
                                            Text("\(formatter1.string(from: trip.startDate)) - \(formatter2.string(from: trip.endDate))")
                                                .foregroundStyle(.white)
                                                .foregroundStyle(.white)
                                                .padding(10)
                                                .font(.title2)
                                                .bold()
                                        }
                                    }
                                }
                                
                                
                                //}
                                .padding(20)
                                /*.fullScreenCover(isPresented: $showItineraryItems) {
                                 ItineraryView(trip: trip)
                                 }*/
                            }
                            
                        }//MARK: ~JW
                        //
                    }
                }.task{
                    // fetching all the data from array
                    try? await  myTrips.getAllTrips()
                }
                .frame(maxHeight: 2000)
                .fixedSize(horizontal: false, vertical: false)
            
                
                //MARK: Past Trips
                Text("Past Trips")
                    .padding(.horizontal, 20)
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(profileVm.myTrips,id: \.id) { trip in
                            if (trip.endDate < Date.now) {
                                NavigationLink {
                                    //profileVm.selectedTrip = trip
                                    ItineraryView(trip: trip)
                                } label: {
                                    ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                                        
                                        // use the link from fb to display an image ~JW
                                        coverPhoto(link: trip.coverPhoto ?? "")
                                        
                                        VStack(alignment: .leading){
                                            HStack {
                                                //Text("End date: \(trip.endDate) Current date > End Date \(Date.now > trip.endDate)")
                                                Text(trip.destination)
                                                    .font(.title)
                                                    .foregroundStyle(Color.white)
                                                    .bold()
                                                Spacer()
                                                
                                                
                                                Button() {
                                                    profileVm.editTrip = trip
                                                    
                                                } label: {
                                                    Image(systemName: "ellipsis")
                                                }
                                                .font(.largeTitle)
                                            }
                                            .foregroundStyle(.white)
                                            .padding(10)
                                            
                                            Text("\(formatter1.string(from: trip.startDate)) - \(formatter2.string(from: trip.endDate))")
                                                .foregroundStyle(.white)
                                                .foregroundStyle(.white)
                                                .padding(10)
                                                .font(.title2)
                                                .bold()
                                        }
                                    }
                                }
                                
                                
                                //}
                                .padding(20)
                                /*.fullScreenCover(isPresented: $showItineraryItems) {
                                 ItineraryView(trip: trip)
                                 }*/
                            }
                            
                        }//MARK: ~JW
                        //
                    }
                }.task{
                    // fetching all the data from array
                    try? await  myTrips.getAllTrips()
                }
                .frame(maxHeight: 2000)
                .fixedSize(horizontal: false, vertical: false)

            }
        } 
        .onAppear() {
            //            alltrips.sort(by: {$0.startDate < $1.startDate})
            profileVm.myTrips = alltrips
            
        }
    }
    func signOut() {
        Task {
            do {
                try await authManager.signOut()
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
    @ViewBuilder
    func coverPhoto(link: String) -> some View {
        VStack(alignment:.leading){
            let imageURL = URL(string: link) ?? URL(string: "")
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    //.containerRelativeFrame(.horizontal, count: 1, spacing: 5)
                    .frame(width: 325, height: 250)
                    .clipped()
                    .overlay(Rectangle().foregroundStyle(.black).background(.black).opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
        }
        
    }
    
    
}


#Preview {
    TripsView()
        .environmentObject(Trips())
        .environmentObject(AuthManager())
        .environmentObject(ProfileViewModel())
    
}
