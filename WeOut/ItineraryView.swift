//
//  ItineraryView.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/26/24.
//

import Foundation
import SwiftUI

struct ItineraryView: View {
    
    //itinerary object with all the days of the trip in it
    var itinerary: [ItineraryDayModel] = [ItineraryDayModel(dayOfTheTrip: "Day 1", tripImage: "Chicago", itinerary: """
8am - Nothing
10am - Breakfast
9pm - Sleep
"""), ItineraryDayModel(dayOfTheTrip: "Day 2", tripImage: "Chicago2", itinerary: """
8am - Wake up
11am - Tour
1pm - Free time
""")]
    
    var body: some View {
        ZStack{
            Color(hex: 0x003459, opacity: 1.0)
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Itinerary")
                    .font(.largeTitle)
                    .foregroundStyle(Color.white)
                    .bold()
                //Each day card for the itinerary
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(itinerary, id: \.self) { itineraryDay in
                            ZStack {
                                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(Color(hex: 0x007EA7))
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
                                    Image(itineraryDay.tripImage)
                                        .resizable()
                                        .scaledToFit()
                                    Text(itineraryDay.itinerary)
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

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
#Preview {
    ItineraryView()
}

