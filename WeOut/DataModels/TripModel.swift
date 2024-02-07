//
//  TripModel.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/31/24.
//

import Foundation
import SwiftUI

struct TripModel: Hashable {
    static func == (lhs: TripModel, rhs: TripModel) -> Bool {
        //Function added to conform to Equatable
        return true
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(startDate)
        hasher.combine(endDate)
        hasher.combine(nameOfTrip)
        hasher.combine(destination)
        hasher.combine(details)
    }
    var startDate: Date
    var endDate: Date
    var nameOfTrip: String
    var destination: String
    var tripImage: Image
    var participants: [ParticipantModel]
    var details: String
}

class CreateTripVM: ObservableObject {
    @Published var startDate: Date = Date.now
    @Published var endDate: Date = Date.now
    @Published var nameOfTrip: String = ""
    @Published var destination: String = ""
    @Published var tripImage: Image = Image("blankImage")
    @Published var participants: [ParticipantModel] = []
    @Published var details: String = ""
    @Published var tripArr: [TripModel] = []
    
    func addToTripArray() {
        let trip = TripModel(startDate: startDate, endDate: endDate, nameOfTrip: nameOfTrip, destination: destination, tripImage: tripImage, participants: [], details: details)
        tripArr.append(trip)
    }
    
    func resetTripProperties() {
        self.startDate = Date.now
        self.endDate = Date.now
        self.nameOfTrip = ""
        self.destination = ""
        self.tripImage = Image("blankImage")
        self.participants = []
        self.details = ""
    }
}
