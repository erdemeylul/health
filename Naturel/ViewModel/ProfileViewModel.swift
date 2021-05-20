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
    var man: User?
    @Published var rating: Double = 0.0
    @Published var ratings = [RatingDoc]()
    @Published var ratingOwners: [String] = []
    @Published var ratingMean:[Int] = []
    @Published var total = 0
    
    @Published var uploadComplete = false
    
    @Published var following = 0
    @Published var followers = 0
    @Published var posts = 0
    @Published var bio = ""
    
    @Published var userPosts = [Post]()

    init(user: User){
        self.user = user
        checkIfUserIsFollow()
        fetchBio()
        fetchUserFollowers()
        fetchUserFollowing()
        fetchUserPosts()
        fetchUserPostsAll()
        getRating()
    }
    
    func follow(){
        guard let uid = user.id else {return}
        UserService.follow(uid:uid){ _ in
            NotificationsViewModel.uploadNotification(toUid: uid, type: .follow)
            self.user.isFollowed = true
            self.fetchUserFollowers()
            self.fetchUserFollowing()
            AuthViewModel.shared.final = true
        }
    }
    
    func unFollow(){
        guard let uid = user.id else {return}
        UserService.unFollow(uid:uid){ _ in
            self.user.isFollowed = false
            self.fetchUserFollowers()
            self.fetchUserFollowing()
            AuthViewModel.shared.final = true
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
    
    func fetchUserFollowing(){
        guard let uid = user.id else {return}
        Firestore.firestore().collection("following").document(uid).collection("user-following").getDocuments { snapshot, _ in
            self.following = snapshot?.documents.count ?? 0
        }
    }
    func fetchUserFollowers(){
        guard let uid = user.id else {return}
        Firestore.firestore().collection("followers").document(uid).collection("user-followers").getDocuments { snapshot, _ in
            self.followers = snapshot?.documents.count ?? 0
        }
    }
 
    
    func saveUserBio(_ bio: String){
        guard let uid = user.id else {return}
        
        Firestore.firestore().collection("users").document(uid).updateData(["bio": bio]) { _ in
            self.user.bio = bio
            self.uploadComplete = true
            self.fetchBio()
        }
    }
    
    func changePic(image: UIImage?){
        guard let image = image else {return}

        guard let uid = AuthViewModel.shared.currentUser?.id else {return}
        
        imageUploader.uploadImage(image: image, type: .profile) { imageUrl in
            Firestore.firestore().collection("users").document(uid).updateData(["profileImageUrl": imageUrl])
        }
    }
    
    func fetchBio(){
        guard let uid = user.id else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            self.man = try? snapshot?.data(as: User.self)
            self.bio = self.man?.bio ?? ""
        }
    }

    func recordRating(rating: Double, userId: String){
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}

        let data = [
            "rating" : rating,
            "owner" : uid
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(userId).collection("ratings").document(uid).setData(data)
    }
    
    func getRating(){
        guard let uid = user.id else {return}

        Firestore.firestore().collection("users").document(uid).collection("ratings").getDocuments { (snapshot, _) in
            guard let documents = snapshot?.documents else {return}
            self.ratings = documents.compactMap({try? $0.data(as: RatingDoc.self)})
            for rating in self.ratings{
                if !self.ratingOwners.contains(rating.owner){
                    self.ratingOwners.append(rating.owner)
                    self.ratingMean.append(rating.rating)
                }
                
                if self.ratingMean.count > 0 {
                    self.total = self.ratingMean.reduce(0, +)
                }
            }
        }
    }
    
    func fetchUserPostsAll(){
        guard let uid = user.id else {return}

        Firestore.firestore().collection("posts").whereField("ownerUid", isEqualTo: uid).getDocuments {snapshot, _ in
            guard let documents = snapshot?.documents else {return}
            let posts = documents.compactMap({try? $0.data(as: Post.self)})
            self.userPosts = posts.sorted(by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
        }
    }
    
    func fetchUserPosts(){
        guard let uid = user.id else {return}
        Firestore.firestore().collection("posts").whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, _ in
            self.posts = snapshot?.documents.count ?? 0
        }
    }
}
