

import SwiftUI
import Kingfisher
import URLImage

struct FeedCell: View {
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
            // user info
            HStack {
                if let user = viewModel.post.user{
                    if AuthViewModel.shared.currentUser?.id == user.id {
                        URLImage(url: URL(string: user.profileImageUrl)!) {image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 45, height: 45)
                                .clipped()
                                .cornerRadius(18)}
                        
                        Text(viewModel.post.ownerUsername)
                            .font(.system(size: 14, weight: .semibold))
                    }else{
                        NavigationLink(destination: ProfileView(user: user)) {
                            URLImage(url: URL(string: user.profileImageUrl)!) {image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 45, height: 45)
                                    .clipped()
                                    .cornerRadius(18)}
                            
                            Text(viewModel.post.ownerUsername)
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                }
            }.frame(minHeight: 45)
            .padding(.bottom, 8)
            .padding(.leading, 8)
            .padding(.trailing, 12)
            
            VStack(){
                URLImage(url: URL(string: viewModel.post.imageUrl)!) {image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, alignment: .center)
                        .frame(maxHeight: 440)
                        .clipped()
                }
            }.frame(minWidth:UIScreen.main.bounds.width ,minHeight: 440)
            
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
                Spacer()
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
    
    func  getActionSheet() -> ActionSheet{
        return ActionSheet(title: Text("Do you want to delete the post?"), message: nil, buttons: [
            .destructive(Text("Delete"), action: {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.deletePost()
                }
                
            }),
            
            .default(Text("Learn more..."), action: {
            }),
            
            .cancel()
        ])
    }
}


