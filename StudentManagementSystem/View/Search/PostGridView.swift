

import SwiftUI
import Kingfisher
import URLImage

struct PostGridView: View {
    private let items = [GridItem(), GridItem(), GridItem()]
    private let width = UIScreen.main.bounds.width / 3

    let config: PostGridConfiguration
    @ObservedObject var viewModel: PostGridViewModel
    

    @State var isPresented = false
    
    init(config: PostGridConfiguration) {
        self.config = config
        self.viewModel = PostGridViewModel(config: config)
    }
    
    var body: some View {
        VStack{
            Text("En Beğenilen Paylaşımlar")
            LazyVGrid(columns: items, spacing: 2, content: {
                ForEach(viewModel.posts) { post in
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
//                .onAppear{
//                    if config == .explore && AuthViewModel.shared.fin {
//                        viewModel.fetchExplorePagePosts()
//                    }
//                    AuthViewModel.shared.fin = false
//                }
            })
        }
    }
}
