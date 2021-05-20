


import SwiftUI
import Kingfisher
import URLImage

struct ProfilePosts: View {
    private let items = [GridItem(), GridItem(), GridItem()]
    private let width = UIScreen.main.bounds.width / 3

    @ObservedObject var viewModel: ProfileViewModel
        
        
    var body: some View {
        LazyVGrid(columns: items, spacing: 2, content: {
            ForEach(viewModel.userPosts) { post in
                NavigationLink(
                    destination: PostFeed(viewModel: FeedCellViewModel(post: post)),
                    label: {

                        URLImage(url: URL(string: post.imageUrl)!) {image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: width, height: width)
                                .clipped()}
                    })
            }
        })
    }
}
