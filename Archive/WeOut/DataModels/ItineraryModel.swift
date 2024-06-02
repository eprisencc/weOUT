//
//  ItineraryDayModel.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/26/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


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



struct Itinerary : Identifiable, Codable {
    @DocumentID var id : String?
    var dayOfTheTrip: String
    var itineraryImage: String
    var agenda: String
    var destination: String
    
    
}
