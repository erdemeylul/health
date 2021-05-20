//
//  ImageUploader.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 17.04.2021.
//

import UIKit
import Firebase

enum UploadType{
    case profile
    case post
    
    var filePath: StorageReference{
        let filename = NSUUID().uuidString

        switch self{
        case .profile:
            return Storage.storage().reference(withPath: "/profile_images/\(filename)")
        case .post:
            return Storage.storage().reference(withPath: "post_images/\(filename)")
        }
    }
}

struct imageUploader{
    static func uploadImage(image: UIImage, type: UploadType ,completion: @escaping(String)-> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        let ref = type.filePath
        ref.putData(imageData, metadata: nil) {_, error in
            if let error = error {
                print("error \(error)")
                return
            }
            
            ref.downloadURL {url, _ in
                guard let imageUrl = url?.absoluteString else {return}
                completion(imageUrl)
            }
            
        }
    }
}
