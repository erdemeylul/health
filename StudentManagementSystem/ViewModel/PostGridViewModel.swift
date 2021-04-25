//
//  PostGridViewModel.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 24.04.2021.
//

import SwiftUI
import Firebase

enum PostGridConfiguration{
    case explore
    case profile(String)
}

class PostGridViewModel: ObservableObject{
    @Published var posts = [Post]()
    let config: PostGridConfiguration
    
    init(config: PostGridConfiguration){
        self.config = config
        fetchPosts(forConfig: config)
    }
    
    func fetchPosts(forConfig config: PostGridConfiguration){
        switch config{
        case .explore:
            fetchExplorePagePosts()
        case .profile(let uid):
            fetchUserPosts(forUid: uid)
        }
    }
    
    func fetchExplorePagePosts(){
        Firestore.firestore().collection("posts").order(by: "likes", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {return}
            self.posts = documents.compactMap({try? $0.data(as: Post.self)})

        }
    }
    
    func fetchUserPosts(forUid uid: String){
        Firestore.firestore().collection("posts").whereField("ownerUid", isEqualTo: uid).getDocuments {snapshot, _ in
            guard let documents = snapshot?.documents else {return}
            let posts = documents.compactMap({try? $0.data(as: Post.self)})
            self.posts = posts.sorted(by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
        }
    }
}
