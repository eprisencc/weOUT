//
//  ProfileViewModel.swift
//  WeOut
//
//  Created by Jonathan Loving on 5/24/24.
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
class ProfileViewModel : ObservableObject {
    static var shared = ProfileViewModel()
    init(){
    }
    // Import Data
    @Published private(set) var currentUser: DBUser? = nil
    @Published  var currentTrip = TripModel()
    @Published  var selectedTrip: TripModel? = nil
    @Published  var myTrips: [TripModel] = []
    
    
    // Editing
    @Published  var editTrip: TripModel? = nil
    @Published  var editItineraryItem: ItineraryModel? = nil
    
    // Images/Trips
    @Published var EventImageURLString = ""
    @Published   var eventImage : UIImage?
    @Published   var photoPickerItem : PhotosPickerItem?

 

    @Published   var newPhoto = Photo()
    @Published   var selectedPhoto: PhotosPickerItem?
    @Published   var uiImageSelected = UIImage()
    @Published   var didSelectImage = false
    
    // FireBase
    let db = Firestore.firestore()
    
    
    
    //MARK: Fetching Functions for users
    // access this users collection
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    // Access the users document in collection
    private func userDocument(userId: String) -> DocumentReference {
        // access the Players profile in FS, using the id of the Authenticated  user
        userCollection.document(userId)
    }
    // Access Users Created Trips
    private func UserFavoriteGameCollection(userId:String) -> CollectionReference{
        userDocument(userId: userId).collection("myTrips")
    }
    
    // Load user Pt 1.
    func fetchCurrentUser(userID: String) async throws -> DBUser {
        try await userDocument(userId: userID).getDocument(as: DBUser.self)
    }
    
    
    // Load user Pt 2.
    func loadCurrentUser() async throws {
        let authDataResult = try  AuthManager.shared.getAuthUser()
        self.currentUser = try await fetchCurrentUser(userID: authDataResult)
        print("👤 Successfully loaded user")
    }
    
    
}




//MARK: Add/update
extension ProfileViewModel {
     
    //New Code
    func saveTrip(user: DBUser,trip:TripModel,photo: Photo,image: UIImage) async -> Bool{
        let db = Firestore.firestore()
        var updatedTrip = trip
        
        let collectionPath = "users/\(user.uid)/myTrips"
        
        if let id = trip.id { // update the data that alrsady here
            do {
                
                try await db.collection(collectionPath).document(id).setData(trip.dictionary)
                print ("Sending the cover photo to the sub collection using")
                let _ = await saveImage(for:  id, photo: photo, image: image)
                updatedTrip.coverPhoto = self.EventImageURLString
                
                print ("Cover Photo sent to sub collection")
                try await addImageToTrip(tripId: id, newUrl: self.EventImageURLString)
//                imageReseter()
                print("😎 Trip updated successfully!")
                return true
            } catch {
                print("🤬ERROR: Could not update data in'games'")
                return false
            }
            
            
            
            
        } else {
            do{
                // setting the users first lat name to host name
                let _ = try await fetchCurrentUser(userID: user.uid)
                // this is the new game being created
                let documentRef = try await db.collection(collectionPath).addDocument(data: trip.dictionary)
                // sends the cover photo to the sub collection using this func
                print ("Sending the cover photo to the sub collection using")
                let _ = await saveImage(for:  documentRef.documentID, photo: photo, image: image)
                print ("Cover Photo sent to sub collection")
                
                // this is to make sure we are updating the the 'game' on xcode when a new value is inputed, so thay we have a id before its in fb
                updatedTrip.coverPhoto = self.EventImageURLString
                print("cover phhoto link: \(updatedTrip.coverPhoto ?? "")")
                try await addImageToTrip(tripId: documentRef.documentID, newUrl: updatedTrip.coverPhoto ?? "")
                
                print ("updating the trips cover photo link")
                
                self.currentTrip = updatedTrip
                self.currentTrip.id = documentRef.documentID
                print ("Updated the current trip struct")
                print("😎 Game Created succesfully")
                 print ("Added image to subpath")
                
//                imageReseter()
                return true
            } catch{
                print("🤬Error: could not add data")
                return false
                
            }
            
        }
        
    }
    
    
    
    // new code
    func updateTrip(user: DBUser,trip:TripModel) async -> Bool{
        let db = Firestore.firestore()
        var updatedTrip = trip
        
        let collectionPath = "users/\(user.uid)/myTrips"
        
        
        
        if let id = trip.id { // update the data that alrsady here
            do {
                try await db.collection(collectionPath).document(id).setData(trip.dictionary)
                let _ = await saveImage(for: id, photo: self.newPhoto, image: self.eventImage ?? UIImage())
                updatedTrip.coverPhoto = self.EventImageURLString
                print("New Url String: \(self.EventImageURLString)")
                try await addImageToTrip(tripId: id, newUrl: self.EventImageURLString)
                self.eventImage = nil
                print ("😎 Trip updated successfully!")
                return true
            } catch {
                print ("🤬ERROR: Could not update data in'myTrips'")
                return false
            }
        } else {
            print("Error: Can not find ID for trip")
            return false
        }
    }
    
    
    

    
    // New Code
    func deleteTrip(userId: String, tripID: String ) async throws  -> Bool {
        let db = Firestore.firestore()
        let collectionPath = "users/\(userId)/myTrips"
        let documentReference = db.collection(collectionPath)
        
        do {
            try await documentReference.document(tripID).delete()
            print("😎 Document successfully deleted!")
            return true
        } catch {
            print("🤬Error deleting document: \(error)")
            return false
        }
    }
    
    
    
    
    // new code
    func imageReseter(){
        self.selectedPhoto = nil
        self.photoPickerItem = nil
        self.EventImageURLString = ""
        self.newPhoto = Photo()
        self.uiImageSelected = UIImage()
        self.eventImage = nil
    }
    
    
    
}
 



//MARK: Imagaes
extension ProfileViewModel{
    
    func saveImage(for tripID: String, photo: Photo, image: UIImage) async -> Bool {
        //
        var  photoName = UUID().uuidString
        
        if photo.id != nil  {// if i have a photo id use the name of the photo id instead of creating a new one, we'll use this so we can update the description of a photo without resaving the photo
            photoName = photo.id!
        }
        guard currentUser != nil else {
            return false
        }
        
        let storage = Storage.storage()
        print("Accessing Storage")
        print("TripID: \(tripID)")
        // save this storage to
        let storageRef = storage.reference().child("\(tripID)/\(photoName).jpeg")
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
                self.EventImageURLString = "\(imageURL)"
                print("UrlLink: \(self.EventImageURLString)")
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
        
        //
        //
        //
        //        // write it the struct instead of the sub path
        
        //        // Saving Photos to database
        //        let db = Firestore.firestore()
        //        //Creating paths for photos to go
        //        let collectionString  = "users/\(currentUser.uid)/myTrips/\(tripID)/coverPhoto"
        //
        //        do {
        //            var newPhoto = photo
        //            //allows us to display the image
        //            newPhoto.imageURLString = self.imageURLString
        //
        //            // updating the database with the meta data of the photo
        //            // instead of using the .addDocument func use the .document() and plug in the document we already have
        //            // this way you are updating the document that already exists instead of creating  a new one
        //            try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
        //            print("😎 Cover Photo Saved successfully")
        //            return true
        //        }catch{
        //            print("🤬 ERROR: Cover Photo coukd not be saved ")
        //            return false
        //        }
        
    }
    // new code
    func addImageToTrip(tripId:String, newUrl: String) async throws{
        guard let currentUser  else {
            return
        }
        let db = Firestore.firestore()
        let data: [String:Any] = [
            "coverPhoto" :  newUrl
        ]
        try await db.collection("users/\(currentUser.uid)/myTrips").document(tripId).updateData(data)
//
    }

}
