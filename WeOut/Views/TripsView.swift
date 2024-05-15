//
//  TripsView.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/26/24.
//

import SwiftUI
import Firebase

struct TripsView: View {
    @State private var showTripsInputSheet = false
    @State private var showEditTripsInputSheet = false
    
    // Trip object with all the trips in it
    @EnvironmentObject var myTrips: Trips
    
    @State var myIndex: Int = -1
    @State var currentIndex: Int = 0
    //@State var myTrips: Trips = Trips()
    var onTap: () -> Void
    
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
                    tripHeading
                    Spacer()
                    
                    tripDetails
                    
                    /*NavigationLink {
                        ItineraryView(destination: createTrip.tripArr[currentIndex].destination)
                        Text("Destination \(createTrip.tripArr[currentIndex].destination)")
                    } label: {
                        tripDetails
                    }*/
                    /*NavigationLink {
                        ItineraryView(trip: )
                        Text("Destination \(createTrip.destination)")
                    } label: {
                        tripDetails
                    }*/
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
        .padding(25)
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
                                    trip.tripImage
                                        .resizable()
                                        .scaledToFit()
                                        .overlay(Rectangle().foregroundStyle(.black).background(.black).opacity(0.3))
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
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
                                            
                                            myTrips.tripImage = trip.tripImage
                                            
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
            }
            .frame(maxHeight: 2000)
            .fixedSize(horizontal: false, vertical: false)
    }
}


#Preview {
    TripsView {
        
    }
        .environmentObject(Trips())
}
