//
//  CommentCell.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 1/1/21.
//

import SwiftUI
import Kingfisher

struct CommentCell: View {
    //let comment: Comment
    @ObservedObject var viewModel: CommentCellViewModel
    
    var body: some View {
        HStack {
            
            if let user = viewModel.comment.user{
                NavigationLink(destination: ProfileView(user: user)) {
                    KFImage(URL(string: viewModel.comment.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                    
                    Text(viewModel.comment.username).font(.system(size: 14, weight: .semibold)) +
                        Text(" \(viewModel.comment.commentText)").font(.system(size: 14)).foregroundColor(.primary)
                }
            }
            
//            KFImage(URL(string: comment.profileImageUrl))
//                .resizable()
//                .scaledToFill()
//                .frame(width: 36, height: 36)
//                .clipShape(Circle())
//
//            Text(comment.username).font(.system(size: 14, weight: .semibold)) +
//                Text(" \(comment.commentText)").font(.system(size: 14))
            
            
            Spacer()
            
            Text(" \(viewModel.comment.timestampString ?? "")")
                .foregroundColor(.gray)
                .font(.system(size: 12))
        }.padding(.horizontal)
    }
}
