//
//  FeedViewModel.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 23.04.2021.
//

import Firebase


class FeedViewModel: ObservableObject{
    @Published var posts = [Post]()
    
    init(){
        fetchPosts()
    }
    
    func fetchPosts(){
        Firestore.firestore().collection("posts").order(by: "timestamp", descending: true).limit(to: 50).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {return}
            self.posts = documents.compactMap({try? $0.data(as: Post.self)})
        }
    }
    
    
}
