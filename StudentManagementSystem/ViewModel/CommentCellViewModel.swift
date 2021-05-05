//
//  CommentCellViewModel.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 2.05.2021.
//

import Foundation
import Firebase

class CommentCellViewModel: ObservableObject{
    private let post: Post

    @Published var comment: Comment
    
    init(comment: Comment, post: Post){
        self.comment = comment
        self.post = post
        fetchCommentUser()
    }
    
    
    func fetchCommentUser(){

        Firestore.firestore().collection("users").document(comment.uid).getDocument { snapshot, _ in
            self.comment.user = try? snapshot?.data(as: User.self)
            print(self.comment.user ?? "")
        }
    }
}
