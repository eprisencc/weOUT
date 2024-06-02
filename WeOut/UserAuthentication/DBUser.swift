//
//  DBUser.swift
//  WeOut
//
//  Created by Jonathan Loving on 5/24/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
 
struct DBUser: Identifiable, Codable{
    @DocumentID var id: String?
    var email : String
    var name: String
    var uid: String
 
    var dictionary: [String: Any]{
        return [
            "email" : email,
            "name" : name,
            "uid" : uid
          ]
        
    }
    
 }


