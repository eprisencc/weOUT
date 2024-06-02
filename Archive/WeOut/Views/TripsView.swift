//
//  TripsView.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/26/24.
//

import SwiftUI
import Firebase

struct TripsView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showTripsInputSheet = false
    @State private var showEditTripsInputSheet = false
    @State private var showLoginSheet = false
    
    // Trip object with all the trips in it
    @EnvironmentObject var myTrips: Trips
    @EnvironmentObject var profileVm: ProfileViewModel

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
                        if let user = profileVm.user{
                            Text("User is not Nil")
                            Text(user.email)
                                .foregroundStyle(.yellow)
                                
                        }
 
 //                        if authManager.authState == .signedIn {
//                            Text("Hi, " + (authManager.user?.displayName ?? "Name placeholder"))
//                                .font(.headline)
//                                .foregroundStyle(Color.titleheadings)
//                                .padding(.horizontal, 25)
//                            
//                            //Text(authManager.user?.email ?? "Email placeholder")
//                                //.font(.subheadline)
//                        }
//                        else {
//                            Text("Sign-in to view data!")
//                                .font(.headline)
//                        }
                        
                    }
                    /*.sheet(isPresented: $showLoginSheet) {
                        LoginView()
                    }*/
                    tripHeading
                    Spacer()
 
                    
                    //print("profile Vm mid code check :\(profileVm.user!)")
                    
                     //if authManager.authState == .signedIn {
//                    if let user = profileVm.user{
//                            VStack{
//                                Text("Showing Data")
//                            Text(user.email)
// 
//                               Text(user.name)
//                                Text(user.uid)
//                                
//                                 
//                            }.foregroundStyle(.yellow)
//                                .font(.title)
//                     }
                 //   }
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
            
            .task{
                do {
                    try await profileVm.loadCurrentUser()
                    
                } catch {
                    print("profile Vm :\(profileVm.user)")
                    
                }
                
            }
        
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
        label: {
            Image(systemName: "plus")
        }
        .sheet(isPresented: $showTripsInputSheet) {
            TripsInputSheet()
                .presentationDetents([.large])
                .background(Color(hex: "1F1F1F").ignoresSafeArea())
        }
        .foregroundColor(.titleheadings)
        .font(.largeTitle)
        }
        .padding(.horizontal, 25)
    }
    var tripDetails: some View {
        //NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(Array($myTrips.tripArr.enumerated()), id: \.element.id) { index, tripBinding in
                        
                        let trip = tripBinding.wrappedValue
                        
                        NavigationLink{
                            // destination
                            ItineraryView(trip: $myTrips.tripArr[index])
                        } label: {
                            
                            
                            //createTrip.whichDestination.append(index)
                            //NavigationStack {
                            //Text("index is \(index)")
                            //Text("current index is \(currentIndex)")
                            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                                VStack {
//                                    trip.tripImage
//                                        .resizable()
//                                        .scaledToFit()
//                                        .overlay(Rectangle().foregroundStyle(.black).background(.black).opacity(0.3))
//                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                }
                                VStack(alignment: .leading){
                                    HStack {
                                        Text(trip.destination)
                                            .font(.title)
                                            .foregroundStyle(Color.white)
                                            .bold()
                                        Spacer()
                                        Button() {
                                            myTrips.destination = trip.destination
                                            
                                            //myTrips.tripImage = trip.tripImage
                                            
                                            showEditTripsInputSheet.toggle()
                                            myIndex = index
                                            
                                        } label: {
                                            Image(systemName: "ellipsis")
                                        }
                                        .font(.largeTitle)
                                        .sheet(isPresented: $showEditTripsInputSheet) {
                                            EditTripsInputSheet( trip: $myTrips.tripArr[myIndex])
                                        }
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
                            .padding(20)
                        }
                    }
                }
            }.task{
                // fetching all the data from array
               try? await  myTrips.getAllTrips()
            }
            .frame(maxHeight: 2000)
            .fixedSize(horizontal: false, vertical: false)
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
    
    
    
}


#Preview {
    TripsView()
        .environmentObject(Trips())
        .environmentObject(AuthManager())
        .environmentObject(ProfileViewModel())

}
