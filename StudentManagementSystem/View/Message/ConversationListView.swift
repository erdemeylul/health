//
//  ContentView.swift
//  Messenger
//
//  Created by Erdem Senol on 19.04.2021.
//

import SwiftUI
import URLImage
import Firebase
import Kingfisher

struct ConversationListView: View {
    @State var otherUsername = ""
    @State var showChat = false
    @State var showSearch = false
    
    @State var otherImage = ""
    @State var otherName = ""
        
    @ObservedObject var model = MessageViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                ForEach(model.conversations, id:\.self){ name in
                    NavigationLink(destination: ChatView(otherUsername: name)){
                        
                        VStack {
                            HStack(spacing: 10){
                                ForEach(model.users){ user in
                                    if name == user.id {

                                        URLImage(url: URL(string: user.profileImageUrl)!) {image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 45, height: 45)
                                                .clipShape(Circle())
                                                .padding()}
                                        Text(user.username)
                                            .bold()
                                            .foregroundColor(.black)
                                            .font(.system(size: 32))
                                        
                                        
                                        Spacer()
                                          
                                        ZStack{
                                            ForEach(model.unreadMessage, id:\.self){ message in
                                                if user.username == message.sender{
                                                    ZStack{
                                                        Circle()
                                                            .foregroundColor(Color.red)
                                                            .frame(width: 30, height: 30)
                                                        Text("!")
                                                            .foregroundColor(.white)
                                                            .fontWeight(.bold)
                                                            .font(.title3)
                                                            .padding()
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                              
                                Spacer()
                            }.onAppear{
                                model.otherUsername = name
                                
                            }
                            Divider()

                        } //endofVStack

                    }//ennavlink
                    .simultaneousGesture(TapGesture().onEnded{
                        model.readMessage(name: name)
                        print("DEBUG hehe \(model.unreadMessage.count)")
                    })
                }
                if !otherUsername.isEmpty{
                    NavigationLink("", destination: ChatView(otherUsername: otherUsername), isActive: $showChat)
                }
            }

        }.onAppear{
            model.getConversations()
        }
    }
    

    
//
//    func final(name: String, completion: @escaping (Int) -> Void) {
//        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
//
//        Firestore.firestore().collection("users").document(uid).collection("chats").document(name).collection("messages").whereField("read", isEqualTo: false).getDocuments { (snapshot, _) in
//            guard let documents = snapshot?.documents.compactMap({ $0.documentID }) else {return}
//
//            let count = documents.count
//            completion(count)
//        }
//    }
    
    
    

}


