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

//                                        KFImage(URL(string: user.profileImageUrl))
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 45, height: 45)
//                                            .clipShape(Circle())
//                                            .padding()
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
//                                        if model.unreadMessages.contains(name){
//                                            Circle()
//                                                .fill(Color.red)
//                                        }else{
//                                            Circle()
//                                                .fill(Color.green)
//                                        }
//                                        Spacer()
//                                        Image(systemName: "chevron.right")
                                    }
                                }
                                Spacer()
                            }.onAppear{
                                model.otherUsername = name
                                print("DEBUG \(model.unreadMessages)\(name)")
                            }
//                            .simultaneousGesture(TapGesture().onEnded{
//                                model.unreadMessages.removeAll{$0 == name}
//                            })

                            Divider()

                            .padding(5)
                        }
                    }
                }
                if !otherUsername.isEmpty{
                    NavigationLink("", destination: ChatView(otherUsername: otherUsername), isActive: $showChat)
                }
            }.navigationTitle("Conversations")

        }.onAppear{
            model.getConversations()
        }
    }

    
}


