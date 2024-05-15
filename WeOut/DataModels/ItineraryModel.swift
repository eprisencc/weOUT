//
//  ItineraryDayModel.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/26/24.
//

import Foundation
import SwiftUI

//Daily Trip Itinerary
struct ItineraryModel: Hashable, Identifiable {
    var id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dayOfTheTrip)
        hasher.combine(agenda)
    }
    
    var dayOfTheTrip: String
    var itineraryImage: Image
    var agenda: String
    var destination: String
    
}
