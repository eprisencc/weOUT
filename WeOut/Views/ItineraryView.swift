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
    
    //itinerary object with all the days of the trip in it
    @State var itinerary: [ItineraryModel] = [] /*[ItineraryDayModel(dayOfTheTrip: "Day 1", tripImage: "Chicago", agenda: """
8am - Nothing
10am - Breakfast
9pm - Sleep
"""), ItineraryDayModel(dayOfTheTrip: "Day 2", tripImage: "Chicago2", agenda: """
8am - Wake up
11am - Tour
1pm - Free time
""")]*/
    
    var body: some View {
        ZStack{
            Color(hex: "#003459")
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack {
                    Text("Itinerary")
                        .font(.largeTitle)
                        .foregroundStyle(Color.white)
                        .bold()
                    Spacer()
                    //Bring up the itinerary input sheet
                    Button {
                        showItinearyInputSheet.toggle()
                    }
                    label: {
                        Image(systemName: "plus")
                    }  .sheet(isPresented: $showItinearyInputSheet) {
                        ItineraryInputSheet(itinerary: itinerary)
                            .presentationDetents([.medium])
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                }
                //Each day card for the itinerary
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(itinerary, id: \.self) { itineraryDay in
                            ZStack {
                                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(Color(hex: "#007EA7"))
                                VStack(alignment: .leading){
                                    HStack {
                                        Text(itineraryDay.dayOfTheTrip)
                                            .font(.title)
                                            .foregroundStyle(Color.white)
                                            .bold()
                                        Spacer()
                                        Button() {
                                            
                                        } label: {
                                            Image(systemName: "ellipsis")
                                        }
                                        .foregroundColor(Color.white)
                                    }
                                    itineraryDay.tripImage
                                        .resizable()
                                        .scaledToFit()
                                    /*Image(itineraryDay.tripImage)
                                        .resizable()
                                        .scaledToFit()*/
                                    Text(itineraryDay.agenda)
                                        .foregroundStyle(Color.white)
                                        .bold()
                                }
                                .padding(20)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(25)
        }
    }
}


#Preview {
    ItineraryView()
}

