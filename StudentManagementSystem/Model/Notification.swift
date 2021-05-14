//
//  Notification.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 24.04.2021.
//

import Firebase
import FirebaseFirestoreSwift

struct Notification: Identifiable, Decodable{
    @DocumentID var id: String?
    
    var postId: String?
    let username: String
    let profileImageUrl: String
    let timestamp: Timestamp
    let type: NotificationType
    let uid: String
    
    var isFollowed: Bool? = false
    
    var post: Post?
    var user: User?
}

enum NotificationType: Int, Decodable{
    case like
    case comment
    case follow
    
    var notifitcationMessage: String{
        switch self {
        case .like: return " gönderini beğendi"
        case .comment: return " gönderine yorum yaptı"
        case .follow: return " seni takibe aldı"
        }
    }
}
