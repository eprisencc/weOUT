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


class ProfileViewModel : ObservableObject {
    @Published private(set) var user: DBUser? = nil
    let db = Firestore.firestore()
    
    func fetchCurrentUser(userID: String) async throws -> DBUser {
        try await db.collection("users").document(userID).getDocument(as: DBUser.self)
    }
    
    init(){
//        self.loadUserData()
    }
    
    
    
    
    
     func loadCurrentUser() async throws {
        let authDataResult = try await AuthManager.shared.getAuthUser()
        self.user = try await fetchCurrentUser(userID: authDataResult)
         print("This is the user being decoded from firebase\(self.user!)")
      }
    
//    func loadUserData() {
//            guard let currentUser = Auth.auth().currentUser else {
//                print("No authenticated user found.")
//                return
//            }
//
//            let db = Firestore.firestore()
//            let userRef = db.collection("users").document(currentUser.uid)
//        print("Referenced Current User from fb")
//
//        print("Aceessing Documents form user ref")
//
//            userRef.getDocument { document, error in
//                if let document = document, document.exists {
//                    let data = document.data()
//                    
//                    self.user = DBUser(email: data?["email"] as? String ?? "",
//                                       name: data?["name"] as? String ?? "",
//                                       uid: document.documentID)
//                    print("\(self.user!)")
//                    print("Current User Decoded from fb.")
//
////                        // Map other fields as needed
////                    )
//                } else {
//                    print("Document does not exist: \(error?.localizedDescription ?? "Unknown error")")
//                }
//            }
//        }
    
    
}

