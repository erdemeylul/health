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
    
    @Published var unreadMessage = [Mess]()
    
    @Published var final = [Mess]()
    
    @Published var unreadMessages: Int = 0
    @Published var count: [Int] = []
    
    var cancellable: AnyCancellable? = nil
    @Published var keyboardIsShowing: Bool = false

    init(){
        fetchUsers()
        setupPublishers()
        getUnreadMessages()
    }
    


    var conversationListener: ListenerRegistration?
    var chatListener: ListenerRegistration?

    var otherUsername = ""
    
    func sendMessage(text: String){
        guard let user = AuthViewModel.shared.currentUser else {return}
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}

        let newMessageId = UUID().uuidString
        let dateString = ISO8601DateFormatter().string(from: Date())
        let dataSender = [
            "text": text,
            "sender": user.username,
            "created": dateString,
            "read": true
        ] as [String : Any]
        
        let dataReceiver = [
            "text": text,
            "sender": user.username,
            "created": dateString,
            "read": false
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(uid).collection("chats").document(otherUsername).collection("messages").document(newMessageId).setData(dataSender)
        
        Firestore.firestore().collection("users").document(otherUsername).collection("chats").document(uid).collection("messages").document(newMessageId).setData(dataReceiver)
        
    }
    
    func createConversation(){
        //guard let user = AuthViewModel.shared.currentUser else {return}
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        let dateString = ISO8601DateFormatter().string(from: Date())


        Firestore.firestore().collection("users").document(uid).collection("chats").document(otherUsername).setData(["created": dateString])
        Firestore.firestore().collection("users").document(otherUsername).collection("chats").document(uid).setData(["created": dateString])
    }
    
    func readMessage(name: String){
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        //let newMessageId = UUID().uuidString


        Firestore.firestore().collection("users").document(uid).collection("chats").document(name).collection("messages").getDocuments { (snapshot, _) in
            guard let documents = snapshot?.documents.compactMap({ $0.documentID }) else {return}
            
            
            for document in documents{
                Firestore.firestore().collection("users").document(uid).collection("chats").document(name).collection("messages").document(document).updateData(["read": true])
            }
        }
        getUnreadMessages()
    }
//
//    func getUnreadMessages(name: String) -> Int{
//        guard let uid = AuthViewModel.shared.userSession?.uid else {return 0}
//
//        Firestore.firestore().collection("users").document(name).collection("chats").document(uid).collection("messages").whereField("read", isEqualTo: false).getDocuments { (snapshot, _) in
//            guard let documents = snapshot?.documents.compactMap({ $0.documentID }) else {return}
//
//            self.unreadMessage = documents.compactMap ({try? $0.data(as: Message.self)})
//
//        }
//        return unreadMessages
//    }
    
    func getUnreadMessages(){
        guard let uid = AuthViewModel.shared.userSession?.uid else {return }
        //guard let user = AuthViewModel.shared.currentUser else {return}

        self.unreadMessage = []
        Firestore.firestore().collection("users").document(uid).collection("chats").getDocuments { (snapshot, _) in
            guard let documents = snapshot?.documents.compactMap({ $0.documentID }) else {return}
            
            print("DEBUG 1 \(documents)")
            
            for doc in documents{
                Firestore.firestore().collection("users").document(uid).collection("chats").document(doc).collection("messages").whereField("read", isEqualTo: false).getDocuments { (snapshot, _) in
                    guard let docs = snapshot?.documents else {return}
                    
                    print("DEBUG 2 \(docs)")
                    
                    self.final = docs.compactMap ({try? $0.data(as: Mess.self)})
                    
                    print("DEBUG 3 \(self.final)")
                    
                    for fin in self.final{
                        self.unreadMessage.append(fin)
                    }
                }
            }
        }
    }
    
    func fetchUsers(){
        Firestore.firestore().collection("users").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {return}
            
            //print("DEBUG 0 \(documents)")
            
            self.users = documents.compactMap ({try? $0.data(as: User.self)})
            
            //print("DEBUG 0\(self.users)")
        }
    }
    


    
    func getConversations(){
        //guard let user = AuthViewModel.shared.currentUser else {return}
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}

        conversationListener = Firestore.firestore().collection("users").document(uid).collection("chats").order(by: "created", descending: true).addSnapshotListener {[weak self] snapshot, error in
            guard let userIds = snapshot?.documents.compactMap({ $0.documentID }),
                  error == nil else {return}
            
            DispatchQueue.main.async {
                self?.conversations = userIds
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
                               created: date,
                               read: false)
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
