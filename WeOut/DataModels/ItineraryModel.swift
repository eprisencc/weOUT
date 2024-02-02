//
//  ItineraryDayModel.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/26/24.
//

import Foundation
import SwiftUI

//Daily Trip Itinerary
struct ItineraryModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dayOfTheTrip)
        hasher.combine(agenda)
    }
    
    var dayOfTheTrip: String
    var tripImage: Image
    var agenda: String
    var tripDay: Int
    
}

class CreateItineraryVM: ObservableObject {
    @Published var dayOfTheTrip: String = ""
    @Published var tripImage: Image = Image("blankImage")
    @Published var agenda: String = ""
    @Published var tripDay: Int = 0
    @Published var itineraryArr: [ItineraryModel] = []
    
    func addToItineraryArray() {
        let itinerary = ItineraryModel(dayOfTheTrip: dayOfTheTrip, tripImage: tripImage, agenda: agenda, tripDay: tripDay)
        itineraryArr.append(itinerary)
        
        self.dayOfTheTrip = ""
        self.tripImage = Image("blankImage")
        self.agenda = ""
        self.tripDay = 0
        
        
        
    }
}
