//
//  PostFeed.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 25.04.2021.
//

import SwiftUI
import Kingfisher
import URLImage


struct PostFeed: View {
    
    @ObservedObject var viewModel: FeedCellViewModel

    @EnvironmentObject var auth: AuthViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var didLike: Bool { return viewModel.post.didLike ?? false }
    
    @State var showActionSheet = false
    
    init(viewModel: FeedCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Spacer()
                Button(action: {
                    showActionSheet.toggle()
                }, label: {
                    if auth.currentUser?.id == viewModel.post.ownerUid{
                        Image("del")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: .center)
                            .shadow(radius: 12)
                    }
                })
                Spacer()
            }
            
            // user info
            HStack {

                if let user = viewModel.post.user{
                    if AuthViewModel.shared.currentUser?.id == user.id {
                        URLImage(url: URL(string: viewModel.post.ownerImageUrl)!) {image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 36, height: 36)
                                .clipped()
                                .cornerRadius(18)}
                        
                       
                        Text(viewModel.post.ownerUsername)
                            .foregroundColor(.primary)
                            .font(.system(size: 14, weight: .semibold))
                    }else{
                        NavigationLink(destination: ProfileView(user: user)){
                            URLImage(url: URL(string: viewModel.post.ownerImageUrl)!) {image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 36, height: 36)
                                    .clipped()
                                    .cornerRadius(18)}
                            
                           
                            Text(viewModel.post.ownerUsername)
                                .foregroundColor(.primary)
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }

                    
                }
                 
                Spacer()
//                Button(action: {
//                    showActionSheet.toggle()
//                }, label: {
//                    if auth.currentUser?.id == viewModel.post.ownerUid{
//                        Image(systemName: "ellipsis")
//                    }
//                })
                .actionSheet(isPresented: $showActionSheet, content: {
                    ActionSheet(title: Text("What do you want to do?"), message: nil, buttons: [
                        .default(Text("Delete")){
                            viewModel.deletePost()
                            presentationMode.wrappedValue.dismiss()
                            //viewModel.fetchPostUser()
                        },
                        .cancel()
                    ])
                })
            }
            .padding(.bottom, 8)
            .padding(.leading, 8)
            .padding(.trailing, 12)
       
            URLImage(url: URL(string: viewModel.post.imageUrl)!) {image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 4, alignment: .center)
                    .frame(maxHeight: 440)
                    .clipped()
                    .padding(.leading, 2)}
            
            // action buttons
            HStack(spacing: 16) {
                Button(action: {
                    didLike ? viewModel.unlike() : viewModel.like()
                }, label: {
                    Image(systemName: didLike ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(didLike ? .red : .black)
                        .frame(width: 20, height: 20)
                        .font(.system(size: 20))
                        .padding(4)
                })
                
                NavigationLink(destination: CommentsView(post: viewModel.post)) {
                    Image(systemName: "bubble.right")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .font(.system(size: 20))
                        .padding(4)
                }
            }
            .padding(.leading, 4)
            .foregroundColor(.black)
            
            // caption
            
            Text(viewModel.likeString)
                .font(.system(size: 14, weight: .semibold))
                .padding(.leading, 8)
                .padding(.bottom, 0.5)
//
            HStack {
                Text(viewModel.post.ownerUsername).font(.system(size: 14, weight: .semibold)) +
                    Text(" \(viewModel.post.caption)")
                    .font(.system(size: 14))
            }.padding(.horizontal, 8)
            
            Text(viewModel.timestampString)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.leading, 8)
                .padding(.top, -2)
        }

    }
}

struct PostFeed_Previews: PreviewProvider {
    static var previews: some View {
        PostFeed(viewModel: FeedCellViewModel(post: postExample ))
    }
}
