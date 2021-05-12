//
//  GetUnreadMessages.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 12.05.2021.
//

import Foundation
import Firebase

class GetUnreadMessages: ObservableObject{
    @Published var unreadMessage = [Mess]()
    @Published var final = [Mess]()
    
    init(){
        getUnreadMessages()
    }

    
    func getUnreadMessages(){
        guard let uid = AuthViewModel.shared.userSession?.uid else {return }
        //guard let user = AuthViewModel.shared.currentUser else {return}

        self.unreadMessage = []
        Firestore.firestore().collection("users").document(uid).collection("chats").getDocuments { (snapshot, _) in
            guard let documents = snapshot?.documents.compactMap({ $0.documentID }) else {return}
            

            for doc in documents{
                Firestore.firestore().collection("users").document(uid).collection("chats").document(doc).collection("messages").whereField("read", isEqualTo: false).getDocuments { (snapshot, _) in
                    guard let docs = snapshot?.documents else {return}
                    
                    
                    self.final = docs.compactMap ({try? $0.data(as: Mess.self)})

                    
                    for fin in self.final{
                        self.unreadMessage.append(fin)
                    }
                }
            }
        }
    }
}
