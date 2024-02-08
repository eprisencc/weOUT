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
    @State var myIndex: Int
    
    //Itinerary object with all the days of the trip in it
    @EnvironmentObject var createItinerary: CreateItineraryVM
    
    var body: some View {
        ZStack{
            //Color(hex: "#003459")
            Image("cloudBack")
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                itineraryHeading
                //Each day card for the itinerary
                itineraryDetails
            }
        }
    }
    var itineraryHeading: some View {
        HStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .clipShape(Circle())
            Text("Itinerary")
                .font(.largeTitle)
                .foregroundStyle(Color.white)
                .bold()
            Spacer()
            //Bring up the itinerary input sheet
            Button {
                showItinearyInputSheet.toggle()
                createItinerary.resetItineraryProperties()
            }
            label: {
                Image(systemName: "plus")
            }  .sheet(isPresented: $showItinearyInputSheet) {
                ItineraryInputSheet(index: -1)
                    .presentationDetents([.large])
            }
            .foregroundColor(.white)
            .font(.largeTitle)
        }
        .padding(25)
    }
    var itineraryDetails: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(createItinerary.itineraryArr.indices, id: \.self) { index in
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(hex: "#007EA7"))
                        VStack(alignment: .leading){
                            HStack {
                                Text(createItinerary.itineraryArr[index].dayOfTheTrip)
                                    .font(.title)
                                    .foregroundStyle(Color.white)
                                    .bold()
                                Spacer()
                                Button() {
                                    
                                    //createItinerary.itineraryArr.remove(at: index)
                                    createItinerary.dayOfTheTrip = createItinerary.itineraryArr[index].dayOfTheTrip
                                    
                                    createItinerary.itineraryImage = createItinerary.itineraryArr[index].tripImage
                                    
                                    createItinerary.agenda = createItinerary.itineraryArr[index].agenda
                                    
                                    showEditItinearyInputSheet.toggle()
                                    myIndex = index
                                    
                                } label: {
                                    Image(systemName: "ellipsis")
                                }
                                .sheet(isPresented: $showEditItinearyInputSheet) {
                                    EditItineraryInputSheet(index: myIndex)
                                        //.presentationDetents([.large])
                                }
                                .foregroundColor(Color.white)
                            }
                            createItinerary.itineraryArr[index].tripImage
                                .resizable()
                                .scaledToFit()
                            
                            Text(createItinerary.itineraryArr[index].agenda)
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                        .padding(20)
                    }
                }
            }
        }
    }
}


#Preview {
    ItineraryView(myIndex: -1)
        .environmentObject(CreateItineraryVM())
}

