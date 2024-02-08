//
//  TripsView.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/26/24.
//

import SwiftUI

struct TripsView: View {
    @State private var showTripInputSheet = false
    
    // Trip object with all the trips in it
    @ObservedObject var createTrip: CreateTripVM
    
    @State var myIndex: Int = -1
    
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
                Image("cloudBack")
                    .resizable()
                    .ignoresSafeArea(/*edges: .top*/)
                VStack(alignment: .leading) {
                    tripHeading
                    Spacer()
                    NavigationLink {
                        ItineraryView()
                    } label: {
                        tripDetails
                    }
                }
            }
        }
    }
    
    var tripHeading: some View {
        HStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .clipShape(Circle())
            Text("Trips")
                .font(.largeTitle)
                .foregroundStyle(Color.titleheadings)
                .bold()
            Spacer()
            //Bring up the Trip input sheet
            Button {
                showTripInputSheet.toggle()
                createTrip.resetTripProperties()
            }
            label: {
                Image(systemName: "plus")
            }
            .sheet(isPresented: $showTripInputSheet) {
                TripsInputSheet(createTrip: createTrip)
                    .presentationDetents([.large])
                    .background(Color(hex: "1F1F1F").ignoresSafeArea())
            }
            .foregroundColor(.titleheadings)
            .font(.largeTitle)
            }
            .padding(25)
    }
    var tripDetails: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(createTrip.tripArr.indices, id: \.self) { index in
                    
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                        VStack {
                            createTrip.tripArr[index].tripImage
                                .resizable()
                                .scaledToFit()
                                .overlay(Rectangle().foregroundStyle(.black).background(.black).opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
                        VStack(alignment: .leading){
                            HStack {
                                Text(createTrip.tripArr[index].destination)
                                    .font(.title)
                                    .foregroundStyle(Color.white)
                                    .bold()
                                Spacer()
                                Button() {
                                    
                                    //createItinerary.itineraryArr.remove(at: index)
                                    createTrip.destination = createTrip.tripArr[index].destination
                                    
                                    createTrip.tripImage = createTrip.tripArr[index].tripImage
                                    
                                    //createItinerary.agenda = createItinerary.itineraryArr[index].agenda
                                    
                                    //showEditItinearyInputSheet.toggle()
                                    myIndex = index
                                    
                                } label: {
                                    Image(systemName: "ellipsis")
                                }
                                //.sheet(isPresented: $showEditItinearyInputSheet) {
                                //EditItineraryInputSheet(index: myIndex)
                                //.presentationDetents([.large])
                            }
                            .foregroundStyle(.white)
                            .padding(10)
                            
                            Text("\(formatter1.string(from: createTrip.tripArr[index].startDate)) - \(formatter2.string(from: createTrip.tripArr[index].endDate))")
                                .foregroundStyle(.white)
                                .foregroundStyle(.white)
                                .padding(10)
                                .font(.title2)
                                .bold()
                        }
                        //                                    createTrip.tripArr[index].tripImage
                        //                                        .resizable()
                        //                                        .scaledToFit()
                        
                        Text(createTrip.tripArr[index].details)
                            .foregroundStyle(Color.white)
                            .bold()
                    }
                    .padding(20)
                }
            }
        }
    }
}


#Preview {
    TripsView(createTrip: CreateTripVM())
        .environmentObject(CreateTripVM())
        .environmentObject(CreateItineraryVM())
}
