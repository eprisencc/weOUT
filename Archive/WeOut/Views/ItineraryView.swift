//
//  ItineraryView.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/26/24.
//

import Foundation
import SwiftUI

struct ItineraryView: View {
    
    @State private var showItinearyInputSheet = false
    @State private var showEditItinearyInputSheet = false
    @State var myIndex: Int = -1
    @Binding var trip: TripModel
    @State var destination: String = "No where"
    
    var body: some View {
        ZStack{
            Image("cloudSandBack")
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                itineraryHeading
                //Each day card for the itinerary
                //itineraryDetails
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
            }  .sheet(isPresented: $showItinearyInputSheet) {
                ItineraryInputSheet(trip: $trip)
                    .presentationDetents([.large])
            }
            .foregroundColor(.titleheadings)
            .font(.largeTitle)
        }
        .padding(25)
    }
//    var itineraryDetails: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                ForEach(Array($trip.itineraryArr.enumerated()), id: \.element.id) { index, itineraryItemBinding in
//                    
//                    let itineraryItem = itineraryItemBinding.wrappedValue
//                    
//                        ZStack {
//                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
//                                .foregroundColor(Color(hex: "#007EA7"))
//                                .padding(8)
//                            VStack(alignment: .leading){
//                                HStack {
//                                    Text(itineraryItem.dayOfTheTrip)
//                                        .font(.title)
//                                        .foregroundStyle(Color.white)
//                                        .bold()
//                                    Spacer()
//                                    Button() {
//                                        showEditItinearyInputSheet.toggle()
//                                        print(itineraryItem.dayOfTheTrip)
//                                        myIndex = index
//                                        
//                                    } label: {
//                                        Image(systemName: "ellipsis")
//                                    }
//                                    .font(.largeTitle)
//                                    .sheet(isPresented: $showEditItinearyInputSheet) {
//                                        EditItineraryInputSheet(itineraryItem: $trip.itineraryArr[myIndex], trip: $trip)
//                                    }
//                                    .foregroundColor(Color.white)
//                                }
//                                itineraryItem.itineraryImage
//                                    .resizable()
//                                    .scaledToFit()
//                                
//                                Text(itineraryItem.agenda)
//                                    .foregroundStyle(Color.white)
//                                    .bold()
//                            }
//                            .padding(20)
//                        }
//                }
//            }
//        }
//    }
}


#Preview {
    ItineraryView(trip: .constant(TripModel(startDate: Date.now, endDate: Date.now, destination: ""/*, tripImage: Image("blankImage")*/)))
}

