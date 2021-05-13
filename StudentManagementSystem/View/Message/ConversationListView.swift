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

                BaseViewContainer {
                            Text("Inbox")
                            //Image(systemName: "envelope.fill")
                }.padding(.top, -70)
                
                ForEach(model.conversations, id:\.self){ name in
                    NavigationLink(destination: ChatView(otherUsername: name)){
                        
                        VStack {
                            HStack{
                                ForEach(model.users){ user in
                                    if name == user.id {

                                        HStack{
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
                                }
                                                                                              
                            }.onAppear{
                                model.otherUsername = name
                                
                            }
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width - 20, height: 1, alignment: .center).padding(.top, -15)
                                .foregroundColor(Color.green)

                        } //endofVStack

                    }
                    //ennavlink
                    .simultaneousGesture(TapGesture().onEnded{
                        model.readMessage(name: name)
                        print("DEBUG hehe \(model.unreadMessage.count)")
                    })
                }
                .padding(.top, -30)
                if !otherUsername.isEmpty{
                    NavigationLink("", destination: ChatView(otherUsername: otherUsername), isActive: $showChat)
                }
            }

        }.onAppear{
            model.getConversations()
        }
    }
}


