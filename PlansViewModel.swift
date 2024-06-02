//
//  PlansViewModel.swift
//  WeOut
//
//  Created by Jacquese Whitson on 6/1/24.
//



import Foundation
import FirebaseAuth
import FirebaseCore
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import PhotosUI
import UIKit
import _PhotosUI_SwiftUI

@MainActor
//MARK:
class PlansViewModel : ObservableObject {
    static var shared = PlansViewModel()
    init(){
    }
    
    
    
    // Firebase
    let db = Firestore.firestore()
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    @Published  var currentPlan = ItineraryModel()
    @Published  var selectedPlan: ItineraryModel? = nil
    @Published  var myPlans: [ItineraryModel] = []
    
    
    // Editing
    @Published  var editPlan: ItineraryModel? = nil
    @Published  var editItineraryItem: ItineraryModel? = nil
    
    // Images
    @Published var planImageURLString = ""
    @Published  var planImage : UIImage?
    @Published  var photoPickerItem : PhotosPickerItem?
    
    //Images Pt.2
    @Published   var newPhoto = Photo()
    @Published   var selectedPhoto: PhotosPickerItem?
    @Published   var uiImageSelected = UIImage()
    @Published   var didSelectImage = false
    
    
    
}

// Add && update plans
extension PlansViewModel{
    // new code
    func addItinerary(to trip: TripModel, with plan: ItineraryModel,image: UIImage) async -> Bool{
        let db = Firestore.firestore()
        try? await ProfileViewModel.shared.loadCurrentUser()
        // get the user
        guard let userID = ProfileViewModel.shared.currentUser?.uid else {
            print("😡 ERROR: Could not load a user")
            return false }
        
        // access the games id
        guard let tripID = trip.id else {
            print("Error: Trip ID == Nil")
            return false
        }
        let  _ =  await SaveImageForPlan(userID: userID, planID: plan.id ?? "", image: image)
        
        
        var updatedItem = plan
        
        let collectionString = "users/\(userID)/myTrips/\(tripID)/itinerarys"
        updatedItem.itineraryImage = self.planImageURLString
        do {
            let _: Void = try await db.collection(collectionString).document().setData(updatedItem.dictionary)
            print("😎 Added itinerary to trip")
            return true
            
        } catch {
            print ("🤬ERROR: Could not update data for itineray '\(error.localizedDescription)")
            return false
        }
    }
    
    // new code
    func updateItinerary(user: DBUser,trip:TripModel, plan: ItineraryModel,image: UIImage) async -> Bool {
        let collectionPath = "users/\(user.uid)/myTrips/\(trip.id ?? "")/itinerarys"
        guard let tripID = trip.id else {
            return false
        }
        if let planID = plan.id { // update the data that alrsady here
            
            var updatedPlan = plan
            
            do {
                print("Updating Plan")
                try await db.collection(collectionPath).document(planID).updateData(updatedPlan.dictionary)
                print("Plan updated")
                print("Saving Image to storage ")
                
                if planImage != nil {
                    let _ = await SaveImageForPlan(userID: user.uid, planID: planID, image: self.planImage ?? UIImage())
                    
                    print("Image Stored")
                    print("Updatign ItineraryImage to: \(self.planImageURLString)")
                    
                    
                    updatedPlan.itineraryImage = self.planImageURLString
                    
                    print("Adding the image to the plans")
                    
                    try await addImageToPlan(user: user.uid, tripID: tripID , planID: planID, newUrl: self.planImageURLString)
                    print("Image Added")
                    
                    self.planImage = nil
                    self.planImageURLString = ""
                }
                
                
                //                      imageReseter()
                print ("😎 Plans updated successfully!")
                return true
            } catch {
                print ("🤬ERROR: Could not update data in'itinerarys'")
                return false
            }
        } else {
            print("Error: Can not find ID for Itinerary")
            return false
        }
    }
    
    
    // new code
    func deletePlan(userId: String, tripID: String,plan: ItineraryModel ) async throws  -> Bool {
        let db = Firestore.firestore()
        let collectionPath = "users/\(userId)/myTrips/\(tripID)/itinerarys"
        let documentReference = db.collection(collectionPath)
        
        do {
            try await documentReference.document(plan.id ?? "").delete()
            print("😎 Document successfully deleted!")
            return true
        } catch {
            print("🤬Error deleting document: \(error)")
            return false
        }
    }
    
}



// For images
extension PlansViewModel {
    func SaveImageForPlan(userID: String, planID: String, image: UIImage) async -> Bool {
        //
        let  photoName = UUID().uuidString
        
        guard !userID.isEmpty else {
            print("Error: Can not find userID to save itinerary image to storage")
            return false
        }
        let storage = Storage.storage()
        print("Accessing Storage")
        print("Plan: \(planID)")
        // save this storage to
        let storageRef = storage.reference().child("\(planID)/\(photoName).jpeg")
        print("New storage reference")
        
        // compressing image
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
            print("🤬 ERROR: could not resize image")
            return false
        }
        
        let metadata = StorageMetadata()
        // Allowds us to dispaly the image in the storgae database
        metadata.contentType = "image/jpg"
        // this will hold the url of the image that we saved
        //        var imageURLString = ""
        
        do {
            // adding the image data to storage (resized, metadata)
            print("Adding image data to storage")
            
            let _ = try await storageRef.putDataAsync(resizedImage,metadata: metadata)
            print("😎 image saved")
            do {
                // gettin the pictures url from storage
                print("trying to dwonload url from storage")
                let imageURL = try await storageRef.downloadURL()
                //turning URL into a string so i can use it to access the image in the app
                self.planImageURLString = "\(imageURL)"
                print("UrlLink: \(self.planImageURLString)")
                return true
            }catch{
                print("🤬 ERROR: could not get imageUrl after saving image")
                return false
            }
        }
        catch {
            print("🤬 ERROR: Uploading image to firebase")
            return false
        }
    }
    
    
    //   New code
    func addImageToPlan(user: String, tripID: String,planID:String, newUrl: String) async throws{
        guard  !user.isEmpty  else {
            return
        }
        let db = Firestore.firestore()
        let data: [String:Any] = [
            "itineraryImage" :  newUrl
        ]
        try await db.collection("users/\(user)/myTrips/\(tripID)/itinerarys").document(planID).updateData(data)
        
    }
}
