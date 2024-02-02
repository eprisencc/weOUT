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
    //var date: Date
    var tripImage: Image
    var agenda: String
    var tripDay: Int
    
}
