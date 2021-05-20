//
//  Post.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 23.04.2021.
//

import FirebaseFirestoreSwift
import Firebase

struct Post: Decodable, Identifiable{
    @DocumentID var id: String?
    
    let ownerUid: String
    let ownerUsername: String
    let caption: String
    var likes: Int
    let imageUrl: String
    let timestamp: Timestamp
    let ownerImageUrl: String
    
    var didLike: Bool? = false
    var user: User?
}

let postExample = Post(ownerUid: "qwe", ownerUsername: "erdem", caption: "hehe", likes: 12, imageUrl: "https://firebasestorage.googleapis.com/v0/b/healthyfood-e063a.appspot.com/o/post_images%2F538E5270-3A2B-453F-837A-785B4B826185?alt=media&token=a1f1db4f-6235-4645-920a-c5b44825c374", timestamp: Timestamp(), ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/healthyfood-e063a.appspot.com/o/profile_images%2F90D3390A-7926-4C36-9B91-F7A9D4556C1E?alt=media&token=a034c011-b7d5-48e3-926b-02c82954e397")


 
