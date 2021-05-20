//
//  NotificationCellViewModel.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 24.04.2021.
//

import SwiftUI
import Firebase

class NotificationCellViewModel: ObservableObject{
    @Published var notification: Notification
    
    init(notification: Notification){
        self.notification = notification
        checkIfUserIsFollowed()
        fetchNotificationPost()
        fetchNotificationUser()
    }
    
    var timestampString: String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timestamp.dateValue(), to: Date()) ?? ""
    }
    
    func follow(){
        UserService.follow(uid: notification.uid){ _ in
            NotificationsViewModel.uploadNotification(toUid: self.notification.uid, type: .follow)
            self.notification.isFollowed = true
        }
    }
    
    func unFollow(){
        UserService.unFollow(uid: notification.uid){ _ in
            self.notification.isFollowed = false
        }
    }
    
    func checkIfUserIsFollowed(){
        guard notification.type == .like else {return}
        
        UserService.checkIfUserIsFollow(uid: notification.uid){ isFollowed in
            self.notification.isFollowed = isFollowed
        }
    }
    
    func fetchNotificationPost(){
        guard let postId = notification.postId else {return}
        
        Firestore.firestore().collection("posts").document(postId).getDocument { snapshot, _ in
            self.notification.post = try? snapshot?.data(as: Post.self)
        }
    }
    
    func fetchNotificationUser(){
        Firestore.firestore().collection("users").document(notification.uid).getDocument { snapshot, _ in
            self.notification.user = try? snapshot?.data(as: User.self)
        }
    }
}
