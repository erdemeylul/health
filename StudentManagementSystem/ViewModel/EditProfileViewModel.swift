//
//  EditProfileViewModel.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 24.04.2021.
//

import SwiftUI
import Firebase

class EditProfileViewModel: ObservableObject{
    var user: User
    @Published var uploadComplete = false
    
    init(user: User){
        self.user = user
    }
    
    func saveUserBio(_ bio: String){
        guard let uid = user.id else {return}
        
        Firestore.firestore().collection("users").document(uid).updateData(["bio": bio]) { _ in
            self.user.bio = bio
            self.uploadComplete = true
        }
    }
}
