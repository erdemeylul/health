//
//  Post.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 23.04.2021.
//

import FirebaseFirestoreSwift
import Firebase

struct Post: Codable, Identifiable{
    @DocumentID var id: String?
    
    let ownerUid: String
    let ownerUsername: String
    let caption: String
    var likes: Int
    let imageUrl: String
    let timestamp: Timestamp
    let ownerImageUrl: String
    
    var didLike: Bool? = false
}


 
