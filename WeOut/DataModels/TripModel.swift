//
//  TripModel.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/31/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


//struct TestTrip: Identifiable, Codable {
//    @DocumentID var id: String?
//    var startDate = Date()
//
//    var dictionary : [String: Any]
//
//}

//Actor
struct TripModel: Identifiable,Codable,Equatable,Hashable{
    @DocumentID var id: String?
    func hash(into hasher: inout Hasher) {
        hasher.combine(startDate)
        hasher.combine(endDate)
        hasher.combine(destination)
    }
    var startDate: Date = Date.now
    var endDate: Date = Date.now
    var destination: String = ""
    var coverPhoto : String? = ""
    //    var tripImage: Image = Image("blankImage")
    
    //    var itineraryArr: [ItineraryModel] = []
    //
    //    mutating func removeItineraryItem(itineraryItem: ItineraryModel) {
    //        if let itineraryIndex = itineraryArr.firstIndex(where: {$0.id == itineraryItem.id }) {
    //            itineraryArr.remove(at: itineraryIndex)
    //        }
    //        else {
    //            print("error")
    //        }
    //    }
    
    
    var dictionary: [String: Any]{
        return [
            "startDate" : Timestamp(date: startDate),
            "endDate" : Timestamp(date: endDate),
            "destination" : destination,
            "coverPhoto" : coverPhoto ?? ""
            
        ]
    }
    
    
    
    
}



class Trips: ObservableObject, Identifiable {
    var id = UUID()
    
    @Published var trip = TripModel()
    @Published var startDate: Date = Date.now
    @Published var endDate: Date = Date.now
    @Published var destination: String = ""
    @Published var tripImage: Image = Image("blankImage")
    @Published var tripArr: [TripModel] = []
    
    func addToTripArray() {
        let trip = TripModel(startDate: startDate, endDate: endDate, destination: destination/*, tripImage: tripImage*/)
        DispatchQueue.main.async {
            self.tripArr.append(trip)
        }
    }
    
    func removeFromTripArray(trip: TripModel) {
        DispatchQueue.main.async {
            if let tripIndex = self.tripArr.firstIndex(where: { $0.id == trip.id }) {
                self.tripArr.remove(at: tripIndex)
            } else {
                print("error")
            }
        }
    }
    
    func resetTripProperties() {
        DispatchQueue.main.async {
            self.startDate = Date.now
            self.endDate = Date.now
            self.destination = ""
            self.tripImage = Image("blankImage")
        }
    }
    
    
    
    
    // firebase functions
    // add trip
    func addTrip(_ trip: TripModel) async -> Bool {
        // connect to firebase
        let db = Firestore.firestore()
        var  newTrip = trip
        newTrip.destination = self.destination
        newTrip.startDate = self.startDate
        newTrip.endDate = self.endDate
        
        // send this data to firebase
        if let id = trip.id{
            do {
                try await db.collection("trips").document(id).setData(newTrip.dictionary)
                return true
            } catch {
                print("Error: COuld not update trip")
                return false
            }
        } else {
            do {
                let documentRef = try await db.collection("trips").addDocument(data: newTrip.dictionary)
                DispatchQueue.main.async { [newTrip] in
                    var updatedTrip = newTrip
                    updatedTrip.id = documentRef.documentID
                    self.trip = updatedTrip
                    self.resetTripProperties()
                }
                print("Data added successfully")
                return true
            } catch {
                print("Error: Could not create trip")
                return false
            }
            
        }
    }
    
    //    func addTrip(user: Player, trip: TripModel) async -> Bool {
    //        // Connect to Firestore
    //        let db = Firestore.firestore()
    //
    //        // Ensure the user has an ID
    //        guard let userID = user.id else {
    //            print("ERROR: Could not get player ID")
    //            return false
    //        }
    //
    //        var newTrip = trip
    //        newTrip.destination = self.destination
    //        newTrip.startDate = self.startDate
    //        newTrip.endDate = self.endDate
    //
    //        // Reference to the current user's sub-collection
    //        let userTripsRef = db.collection("users").document(userID).collection("trips")
    //
    //        // Send this data to Firestore
    //        do {
    //            if let tripID = trip.id {
    //                // If trip already has an ID, update the existing document
    //                try await userTripsRef.document(tripID).setData(newTrip.dictionary)
    //                print("Data updated successfully")
    //            } else {
    //                // If trip doesn't have an ID, add a new document
    //                let documentRef = try await userTripsRef.addDocument(data: newTrip.dictionary)
    //                newTrip.id = documentRef.documentID
    //                print("Data added successfully")
    //            }
    //            return true
    //        } catch {
    //            print("Error: \(error.localizedDescription)")
    //            return false
    //        }
    //    }
    
    
    // fetch trips
    func fetchAllTrips() async -> [TripModel] {
        let db = Firestore.firestore()
        
        
        // when we do get a trip put it here
        var trips: [TripModel] = []
        
        do {
            let snapShot = try await db.collection("trips").getDocuments()
            
            for document in snapShot.documents {
                let trip = try document.data(as: TripModel.self)
                
                trips.append(trip)
            }
            
            
        } catch {
            print("Error: could not fetch data \(error.localizedDescription)")
        }
        
        return trips
    }
    func getAllTrips() async throws {
        let trips = await fetchAllTrips()
        DispatchQueue.main.async {
            self.tripArr = trips
        }
    }
    
    //    func adduser(_ user: ) async -> Bool {
    //        // connect to firebase
    //        let db = Firestore.firestore()
    //         // send this data to firebase
    //        if let id = user.id{
    //            do {
    //                try await db.collection("trips").document(id).setData(["":""])
    //                return true
    //            } catch {
    //                print("Error: COuld not update trip")
    //                return false
    //            }
    //        } else {
    //            do {
    //                let documentRef = try await db.collection("trips").addDocument(data: newTrip.dictionary)
    //                //
    //                self.trip = newTrip
    //                self.trip.id = documentRef.documentID
    //                resetTripProperties()
    //                print("Data added successfully")
    //                return true
    //            } catch{
    //                print("Error: Could not create trip")
    //                return false
    //            }
    //
    //        }
    //    }
    
    
    
    // add subCollection for Itinerary
    
    
}
