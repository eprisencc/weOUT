//
//  TripModel.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/31/24.
//

import Foundation
import SwiftUI

struct TripModel {
    var startDate: Date
    var endDate: Date
    var nameOfTrip: String
    var destination: String
    var image: Image
    var participants: [ParticipantModel]
    var details: String
}
