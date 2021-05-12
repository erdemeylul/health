//
//  FeedCellViewModel.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 23.04.2021.
//

import SwiftUI
import Firebase

class FeedCellViewModel: ObservableObject{
    @Published var post: Post
    
    var likeString: String{
        let label = post.likes == 1 ? "like" : "likes"
        return "\(post.likes) \(label)"
    }
    
    var timestampString: String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: post.timestamp.dateValue(), to: Date()) ?? ""
    }
    
    init(post: Post){
        self.post = post
        checkIfUserLikedPost()
        fetchPostUser()
    }
    
    func like(){
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        guard let postId = post.id else {return}
        Firestore.firestore().collection("posts").document(post.id ?? "").collection("post-likes").document(uid).setData([:]){_ in
            Firestore.firestore().collection("users").document(uid).collection("user-likes").document(postId).setData([:]){ _ in
                
                Firestore.firestore().collection("posts").document(postId).updateData(["likes": self.post.likes + 1])
                NotificationsViewModel.uploadNotification(toUid: self.post.ownerUid, type: .like, post: self.post)
                self.post.didLike = true
                self.post.likes += 1
            }
        }
    }
    
    func unlike(){
        guard post.likes > 0 else {return}
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        guard let postId = post.id else {return}
        Firestore.firestore().collection("posts").document(post.id ?? "").collection("post-likes").document(uid).delete{_ in
            Firestore.firestore().collection("users").document(uid).collection("user-likes").document(postId).delete{ _ in
                
                Firestore.firestore().collection("posts").document(postId).updateData(["likes": self.post.likes - 1])
                self.post.didLike = false
                self.post.likes -= 1
            }
        }
        
    }
    
    func checkIfUserLikedPost(){
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        guard let postId = post.id else {return}
        
        Firestore.firestore().collection("users").document(uid).collection("user-likes").document(postId).getDocument{ snapshot, _ in
            guard let didLike = snapshot?.exists else {return}
            self.post.didLike = didLike
        }
    }
    
    func deletePost(){
        guard let postId = post.id else {return}

        Firestore.firestore().collection("posts").document(postId).delete()
    }
    
    func fetchPostUser(){

        Firestore.firestore().collection("users").document(post.ownerUid).getDocument { snapshot, _ in
            self.post.user = try? snapshot?.data(as: User.self)
            print("DEBUG eylul bu kadar cektim")
        }
    }
}
