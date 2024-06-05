//
//  ItineraryView.swift
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

struct ItineraryView: View {
    
    @State private var showItinearyInputSheet = false
    @State private var showEditItinearyInputSheet = false
    //@State var myIndex: Int = -1
    var trip: TripModel
    //@State var destination: String = "No where"
    @EnvironmentObject var profileVm: ProfileViewModel
    @FirestoreQuery(collectionPath: "users") var itineraryItems : [ItineraryModel]
    var sortedItineraryItems: [ItineraryModel] {
        itineraryItems.sorted { item1, item2 in
               item1.dayOfTheTrip < item2.dayOfTheTrip
           }
    }
    var body: some View {
        ZStack{
            Image("newCloudsBack")
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                itineraryHeading
                Spacer()
                //Each day card for the itinerary
                itineraryDetails
                
            }
            .padding()
        }
        
        .task {
            try? await profileVm.loadCurrentUser()
            if let user = profileVm.currentUser{
                $itineraryItems.path = "users/\(user.uid)/myTrips/\(trip.id ?? "")/itinerarys"
            }
        }
        .onAppear{
            if let user = profileVm.currentUser{
                $itineraryItems.path = "users/\(user.uid)/myTrips/\(trip.id ?? "")/itinerarys"
            }
        }
        
        
    }
    
    var itineraryHeading: some View {
        HStack {
            Text("Itinerary")
                .font(.largeTitle)
                .foregroundStyle(Color.titleheadings)
                .bold()
            Spacer()
            //Bring up the itinerary input sheet
            Button {
                showItinearyInputSheet.toggle()
            }
        label: {
            Image(systemName: "plus")
        }
        .sheet(isPresented: $showItinearyInputSheet) {
            ItineraryInputSheet(itinerary: ItineraryModel(), trip: trip)
                .presentationDetents([.large])
        }
        .foregroundColor(.titleheadings)
        .font(.largeTitle)
        }
        .padding(.horizontal, 25)
    }
    
    var itineraryDetails: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(sortedItineraryItems) { itineraryItem in
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 25.0)
                            .foregroundStyle(Color(hex: "#007EA7") ?? Color.blue)
                            .padding(8)
                        VStack(alignment: .leading){
                            HStack {
                                Text(itineraryItem.dayOfTheTrip)
                                    .font(.title)
                                    .foregroundStyle(Color.white)
                                    .bold()
                                Spacer()
                            }
                            
                            DisplayPhoto(link: .constant(itineraryItem.itineraryImage))
                            
                            Text(itineraryItem.agenda)
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                        .padding(20)
                        
                        Button() {
                            
                            profileVm.editItineraryItem = itineraryItem
                            print("Itinerary Data \(profileVm.editItineraryItem!)")

                        } label: {
                            Image(systemName: "ellipsis")
                        }
                        .sheet(item: $profileVm.editItineraryItem) { plan in
                            EditItineraryInputSheet(itineraryItem: plan, trip: trip)
                        }
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .padding(.trailing, 30)
                        .padding(.top, 20)
                    }
                    
                }
            }
        }
    }
    
}


#Preview {
    ItineraryView(trip: TripModel())
        .environmentObject(ProfileViewModel())
}

