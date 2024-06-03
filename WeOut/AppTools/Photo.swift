//
//  Photo.swift
//  WeOut
//
//  Created by Jacquese Whitson on 5/29/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

// why dont you do the same thing with the DbUser struct ? u could easily give it a dictinary then create a func that going to add the username to the  file
struct Photo : Identifiable,Codable,Equatable {
    @DocumentID var id: String?
    var imageURLString = ""
    var description = ""
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    var dictionary : [String: Any]{
        return[ "imageURLString" : imageURLString,"description" :  description,
                "reviewer" : reviewer, "postedOn" : Timestamp(date: Date())]
    }


    
}

