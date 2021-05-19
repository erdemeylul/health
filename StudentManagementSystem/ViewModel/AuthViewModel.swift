//
//  AuthViewModel.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 17.04.2021.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var didSendResetPasswordLink = false
    @Published var show = false
    @Published var final = false
    @Published var fin = false
    
    static let shared = AuthViewModel()
    
    init(){
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func login(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                self.show = true
                return
            }
            
            guard let user = result?.user else {return}
            self.userSession = user
            self.fetchUser()
        }
    }
    
    func resgister(withEmail email: String, password: String, image: UIImage?, username: String, role: String, city: String){
        guard let image = image else {return}
        imageUploader.uploadImage(image: image, type: .profile) { imageUrl in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.show = true
                    return
                }
                guard let user = result?.user else {return}
                print("successfully created user")
                
                let data = [
                    "email": email,
                    "role": role,
                    "username": username,
                    "profileImageUrl": imageUrl,
                    "city": city,
                    "uid": user.uid,
                ]
                
                Firestore.firestore().collection("users").document(user.uid).setData(data) { _ in
                    self.userSession = user
                    self.fetchUser()
                }
            }
        }
    }
    
    func signout(){
        self.userSession = nil
        try? Auth.auth().signOut()
    }
    
    func resetPassword(withEmail email: String){
        Auth.auth().sendPasswordReset(withEmail: email) {error in
            if let error = error{
                print("failed to send link \(error.localizedDescription)")
                self.show = true
                return
            }
            self.didSendResetPasswordLink = true
        }
    }
    
    func fetchUser(){
        guard let uid = userSession?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else {return}
            self.currentUser = user
        }
    }
}
