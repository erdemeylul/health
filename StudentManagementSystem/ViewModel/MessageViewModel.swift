//
//  MessageViewModel.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 29.04.2021.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import Combine

struct MessViewModel{
    let message: Message
    
    var messageText: String {
        message.text
    }
    
    var messageId: String {
        message.id ?? ""
    }
}

class MessageViewModel: ObservableObject{
    @Published var messages: [Message] = []
    @Published var conversations: [String] = []
    @Published var users = [User]()
    
    @Published var unreadMessages: [String] = []
    
    var cancellable: AnyCancellable? = nil
    @Published var keyboardIsShowing: Bool = false

    init(){
        fetchUsers()
        setupPublishers()
    }
    


    var conversationListener: ListenerRegistration?
    var chatListener: ListenerRegistration?

    var otherUsername = ""
    
    func sendMessage(text: String){
        guard let user = AuthViewModel.shared.currentUser else {return}
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}

        let newMessageId = UUID().uuidString
        let dateString = ISO8601DateFormatter().string(from: Date())
        let data = [
            "text": text,
            "sender": user.username,
            "created": dateString
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(uid).collection("chats").document(otherUsername).collection("messages").document(newMessageId).setData(data)
        
        Firestore.firestore().collection("users").document(otherUsername).collection("chats").document(uid).collection("messages").document(newMessageId).setData(data)
    }
    
    func createConversation(){
        //guard let user = AuthViewModel.shared.currentUser else {return}
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        let dateString = ISO8601DateFormatter().string(from: Date())


        Firestore.firestore().collection("users").document(uid).collection("chats").document(otherUsername).setData(["created": dateString])
        Firestore.firestore().collection("users").document(otherUsername).collection("chats").document(uid).setData(["created": dateString])
    }
    
    func getConversations(){
        //guard let user = AuthViewModel.shared.currentUser else {return}
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}

        conversationListener = Firestore.firestore().collection("users").document(uid).collection("chats").order(by: "created", descending: true).addSnapshotListener {[weak self] snapshot, error in
            guard let userIds = snapshot?.documents.compactMap({ $0.documentID }),
                  error == nil else {return}
            
            DispatchQueue.main.async {
                self?.conversations = userIds
                self?.unreadMessages = userIds
            }
        }
    }
    
    func observeChat(){
        guard let user = AuthViewModel.shared.currentUser else {return}
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}

        createConversation()
        chatListener = Firestore.firestore().collection("users").document(uid).collection("chats").document(otherUsername).collection("messages").addSnapshotListener {[weak self] snapshot, error in
            guard let objects = snapshot?.documents.compactMap({ $0.data() }),
                  error == nil else {return}
            
            let messages: [Message] = objects.compactMap({
                guard let date = ISO8601DateFormatter().date(from: $0["created"] as? String ?? "") else {
                    return nil
                }
                return Message(text: $0["text"] as?  String ?? "",
                               type: $0["sender"] as? String == user.username ? .sent : .received,
                               created: date)
            }).sorted(by: {first, second in
                return first.created < second.created
            })
            
            DispatchQueue.main.async {
                self?.messages = messages
            }
        }
    }
    
    func searchUsers(queryText: String, completion: @escaping([String])->Void){
        Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
            guard let usernames = snapshot?.documents.compactMap({ $0.documentID }),
                  error == nil else {
                completion([])
                return
            }
            let filtered = usernames.filter ({
                $0.lowercased().hasPrefix(queryText.lowercased())
            })
             
            completion(filtered)
        }
    }
    
    func fetchUsers(){
        Firestore.firestore().collection("users").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {return}
            
            self.users = documents.compactMap ({try? $0.data(as: User.self)})
        }
    }
    
    private let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification).map({ _ in true })

    private let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification).map({ _ in false })

    private func setupPublishers(){
        cancellable = Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .subscribe(on: DispatchQueue.main)
            .assign(to: \.keyboardIsShowing, on: self)
    }
    
    deinit{
        cancellable?.cancel()
    }
}
