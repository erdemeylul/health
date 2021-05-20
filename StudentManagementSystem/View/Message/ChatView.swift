//
//  ChatView.swift
//  Messenger
//
//  Created by Erdem Senol on 19.04.2021.
//

import SwiftUI
import Combine
import Firebase
import URLImage

struct CustomField: ViewModifier{
    
    func body(content: Content) -> some View {
        return content
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
    }
}

struct ChatView: View {
    @StateObject var model = MessageViewModel()
    //@State private var cancellables: AnyCancellable?
    @Environment(\.presentationMode) var presentationMode

    @State private var scrollProxy: ScrollViewProxy? = nil
    
    @State var message = ""
    let otherUsername: String
    
    @State var username: String = ""
    @State var userImageUrl: String = ""
    
    @State var user: User?
    

    
    init(otherUsername: String){
        self.otherUsername = otherUsername
    }
    
    var body: some View {
        VStack {
                
            HStack{
                Spacer()
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
                if userImageUrl.count > 0{
                    URLImage(url: URL(string: userImageUrl)!) {image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36)
                            .clipped()
                            .cornerRadius(18)
                    }
                }
                Text(username)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                Spacer()
            }.background(Color.white)
            .padding(.bottom, -8)

                ScrollView{
                    ScrollViewReader{scrollView in
                        VStack {
                            ForEach(model.messages.indices, id:\.self){index in
                                let message = model.messages[index]
                                
                                ChatRow(text: message.text, type: message.type)
                                    .padding(8)
                                    .id(index)
                                    .animation(.easeIn)
                                    .transition(.move(edge: message.type == .sent ? .trailing : .leading))
                            }
                        }
                        .onAppear{
                            scrollProxy = scrollView
                        }
                    }
                }.navigationBarHidden(true)
                .background(Image("bg").resizable().scaledToFill())
                .onChange(of: model.keyboardIsShowing) { _ in
                        scrollToBottom()
                }
                .onChange(of: model.messages) { _ in
                    scrollToBottom()
                }
            
            HStack{
                TextField("mesaj...", text: $message)
                    .modifier(CustomField())
                    .disableAutocorrection(true)
                    
                Button(action: {
                    model.otherUsername = otherUsername
                    guard !message.trimmingCharacters(in: .whitespaces).isEmpty else{
                        return
                    }
                    model.sendMessage(text: message)
                    message = ""
                    //hideKeyboard()
                }, label: {
                    Image(systemName: "leaf.fill")
                        .font(.system(size:33))
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(message.count > 0 ? Color("koyuyesil") : Color.gray)
                        .animation(.default)
                        .frame(width: 60, height:60)
                })
                
            }
        }.onAppear{
            model.otherUsername = otherUsername
            model.observeChat()
            getUser()
        }
        .onTapGesture {
            hideKeyboard()
            model.keyboardIsShowing = false
        }
    }
    
    func scrollToBottom(){
        withAnimation{
            scrollProxy?.scrollTo(model.messages.count - 1, anchor: .bottom)
        }
    }
    
    func getUser(){
        Firestore.firestore().collection("users").document(otherUsername).getDocument { (snapshot, _) in
            self.user = try? snapshot?.data(as: User.self)
            self.username = user?.username ?? ""
            self.userImageUrl = user?.profileImageUrl ?? ""
        }
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(otherUsername: "erdem")
//    }
//}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


