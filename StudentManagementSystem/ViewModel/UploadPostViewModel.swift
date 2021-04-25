//
//  UploadPostViewModel.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 23.04.2021.
//

import SwiftUI
import Firebase


class UploadPostViewModel: ObservableObject{
    
    func uploadPost(caption: String, image: UIImage, completion: FirestoreCompletion){
        guard let user = AuthViewModel.shared.currentUser else {return}
        
        imageUploader.uploadImage(image: image, type: .post) { imageUrl in
            let data = [
                "caption": caption,
                "timestamp": Timestamp(date: Date()),
                "likes": 0,
                "imageUrl": imageUrl,
                "ownerUid": user.id ?? "",
                "ownerImageUrl": user.profileImageUrl,
                "ownerUsername":user.username] as [String:Any]
            
            Firestore.firestore().collection("posts").addDocument(data: data, completion: completion)
        }
    }
}
