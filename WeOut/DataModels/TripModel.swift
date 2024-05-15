//
//  TripModel.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/31/24.
//

import Foundation
import SwiftUI

struct TripModel: Hashable, Identifiable {
    var id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(startDate)
        hasher.combine(endDate)
        hasher.combine(destination)
    }
    var startDate: Date
    var endDate: Date
    var destination: String
    var tripImage: Image
    var itineraryArr: [ItineraryModel] = []
    
    mutating func removeItineraryItem(itineraryItem: ItineraryModel) {
        if let itineraryIndex = itineraryArr.firstIndex(where: {$0.id == itineraryItem.id }) {
            itineraryArr.remove(at: itineraryIndex)
        }
        else {
            print("error")
        }
    }
}

class Trips: ObservableObject, Identifiable {
    var id = UUID()
    
    @Published var startDate: Date = Date.now
    @Published var endDate: Date = Date.now
    @Published var destination: String = ""
    @Published var tripImage: Image = Image("blankImage")
    @Published var tripArr: [TripModel] = []
    
    func addToTripArray() {
        let trip = TripModel(startDate: startDate, endDate: endDate, destination: destination, tripImage: tripImage)
        tripArr.append(trip)
    }
    
    func removeFromTripArray(trip: TripModel) {
        if let tripIndex = tripArr.firstIndex(where: {$0.id == trip.id }) {
            tripArr.remove(at: tripIndex)
        }
        else {
            print("error")
        }
    }
    
    func resetTripProperties() {
        self.startDate = Date.now
        self.endDate = Date.now
        self.destination = ""
        self.tripImage = Image("blankImage")
    }
}
