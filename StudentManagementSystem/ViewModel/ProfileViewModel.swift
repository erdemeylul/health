//
//  ProfileViewModel.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 22.04.2021.
//

import SwiftUI
import Firebase

class ProfileViewModel: ObservableObject{
    @Published var user: User
    
    init(user: User){
        self.user = user
        checkIfUserIsFollow()
        fetchUserStats()
    }
    
    func follow(){
        guard let uid = user.id else {return}
        UserService.follow(uid:uid){ _ in
            NotificationsViewModel.uploadNotification(toUid: uid, type: .follow)
            self.user.isFollowed = true
        }
    }
    
    func unFollow(){
        guard let uid = user.id else {return}
        UserService.unFollow(uid:uid){ _ in
            self.user.isFollowed = false
        }
    }
    
    func checkIfUserIsFollow(){
        guard !user.isCurrentUser else {return}

        guard let uid = user.id else {return}
        UserService.checkIfUserIsFollow(uid: uid){ isFollowed in
            self.user.isFollowed = isFollowed
        }
    }
    
    func fetchUserStats(){
        guard let uid = user.id else {return}
        Firestore.firestore().collection("following").document(uid).collection("user-following").getDocuments {snapshot, _ in
            guard let following = snapshot?.documents.count else {return}
            Firestore.firestore().collection("followers").document(uid).collection("user-followers").getDocuments {snapshot, _ in
                guard let followers = snapshot?.documents.count else {return}
                
                Firestore.firestore().collection("posts").whereField("ownerUid", isEqualTo: uid).getDocuments {snapshot, _ in
                    guard let posts = snapshot?.documents.count else {return}
                    self.user.stats = UserStats(following: following, posts: posts, followers: followers)
                }
            }
        }

    }
}
