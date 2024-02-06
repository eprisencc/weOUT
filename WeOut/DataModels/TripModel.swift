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
    var TripImage: Image
    var participants: [ParticipantModel]
    var details: String
}

class CreateTripVM: ObservableObject {
    @Published var startDate: Date = Date.now
    @Published var endDate: Date = Date.now
    @Published var nameOfTrip: String = ""
    @Published var destination: String = ""
    @Published var TripImage: Image = Image("blankImage")
    @Published var participants: [ParticipantModel] = []
    @Published var details: String = ""
    @Published var tripArr: [TripModel] = []
}
