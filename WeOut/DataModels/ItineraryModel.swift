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
    
}

class CreateItineraryVM: ObservableObject {
    @Published var dayOfTheTrip: String = ""
    @Published var itineraryImage: Image = Image("blankImage")
    @Published var agenda: String = ""
    @Published var itineraryArr: [ItineraryModel] = []
    //@Published var itineraryDic: [String: [ItineraryModel]] = [:]
    
    func addToItineraryArray(/*destination: String*/) {
        let itinerary = ItineraryModel(dayOfTheTrip: dayOfTheTrip, tripImage: itineraryImage, agenda: agenda)
        itineraryArr.append(itinerary)
        
        
        /*if !(itineraryDic[destination]?.isEmpty ?? true) {
            itineraryDic[destination] = [itinerary]
        } else {
            itineraryDic[destination]?.append(itinerary)
        }*/
    }
    
    func resetItineraryProperties() {
        self.dayOfTheTrip = ""
        self.itineraryImage = Image("blankImage")
        self.agenda = ""
    }
    
    func addToExistingItineraryArray(index: Int) {
        let itinerary = ItineraryModel(dayOfTheTrip: dayOfTheTrip, tripImage: itineraryImage, agenda: agenda)
        print("Add to existing itinerary array index \(index)")
        itineraryArr[index] = itinerary
    }
}
