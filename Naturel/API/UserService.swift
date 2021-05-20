//
//  UserService.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 22.04.2021.
//

import Firebase

typealias FirestoreCompletion = ((Error?)-> Void)?

struct UserService{
    
    
    static func follow(uid: String, completion: ((Error?)-> Void)?){
        guard let currentUid = AuthViewModel.shared.userSession?.uid else {return}
        
        Firestore.firestore().collection("following").document(currentUid).collection("user-following").document(uid).setData([:]) { _ in
            Firestore.firestore().collection("followers").document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unFollow(uid: String, completion: ((Error?)-> Void)?){
        guard let currentUid = AuthViewModel.shared.userSession?.uid else {return}

        Firestore.firestore().collection("following").document(currentUid).collection("user-following").document(uid).delete { _ in
            Firestore.firestore().collection("followers").document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    
    }
    
    static func checkIfUserIsFollow(uid: String, completion: @escaping(Bool)-> Void){
        guard let currentUid = AuthViewModel.shared.userSession?.uid else {return}
        
        Firestore.firestore().collection("following").document(currentUid).collection("user-following").document(uid).getDocument{ snapshot, _ in
            guard let isFollowed = snapshot?.exists else {return}
            
            completion(isFollowed)
        }
    }
}
