

import SwiftUI
import URLImage


struct ProfileView: View {
    let user: User
    var uid: String?
    @ObservedObject var viewModel: ProfileViewModel
    
    @EnvironmentObject var model: AuthViewModel
    var isFollowed: Bool { return viewModel.user.isFollowed ?? false }
    @State var showEditProfile = false
    @State var otherUsername = ""
    @State var show = false
    
    init(user: User) {
        self.user = user
        self.viewModel = ProfileViewModel(user: user)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(alignment: .leading) {
                    HStack {
                        URLImage(url: URL(string: viewModel.user.profileImageUrl)!) {image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .padding(.leading)}
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            UserStatView(value: viewModel.posts, title: "Posts")
                            UserStatView(value: viewModel.followers, title: "Followers")
                            UserStatView(value: viewModel.following, title: "Following")

                        }.padding(.trailing, 32)
                    }
                    
                    VStack(alignment: .leading){
                        Text(viewModel.user.username)
                            .font(.system(size: 15, weight: .semibold))
                            .padding([.leading, .top])
                        
                        Text(viewModel.bio)
                            .font(.system(size: 15))
                            .padding(.leading)
                            .padding(.top, 1)
                    }
                     
                    HStack {
                        Spacer()
                        
                        //ProfileActionButtonView(viewModel: viewModel)
                        if viewModel.user.isCurrentUser {
                            Button(action: { showEditProfile.toggle() }, label: {
                                Text("Edit Profile")
                                    .font(.system(size: 14, weight: .semibold))
                                    .frame(width: 360, height: 32)
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }).sheet(isPresented: $showEditProfile) {
                                //EditProfileView(user: $viewModel.user)
                                EditBio(viewModel: ProfileViewModel(user: viewModel.user), bioText: $viewModel.bio)
                            }
                            
                        } else {
                            VStack{
                                HStack{
                                    Spacer()
                                    if viewModel.user.role == "seller" {
                                        if viewModel.ratingMean.count > 0 {
                                            ZStack{
                                                Circle()
                                                    .foregroundColor(Color.green)
                                                    .frame(width: 60, height: 60)
                                                Text("\(Double(Double(viewModel.total) / Double(viewModel.ratingMean.count)).rounded(toPlaces: 1).removeZerosFromEnd())")
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 38))
                                            }
                                            Image(systemName: "star.fill")
                                                .foregroundColor(Color.yellow)
                                                .font(.system(size: 40))
                                        }else{
                                            Text("No Ratings")
                                        }
                                    }
                                    Spacer()
                                }.padding(.bottom)
                                
                                HStack {
                                    Button(action: { isFollowed ? viewModel.unFollow() : viewModel.follow() }, label: {
                                        Text(isFollowed ? "Following" : "Follow")
                                            .font(.system(size: 14, weight: .semibold))
                                            .frame(width: 172, height: 32)
                                            .foregroundColor(isFollowed ? .black : .white)
                                            .background(isFollowed ? Color.white : Color.blue)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 3)
                                                    .stroke(Color.gray, lineWidth: isFollowed ? 1 : 0)
                                            )
                                    }).cornerRadius(3)

                                    NavigationLink(destination: ChatView(otherUsername: viewModel.user.id ?? "")) {
                                        Text("Message")
                                            .font(.system(size: 14, weight: .semibold))
                                            .frame(width: 172, height: 32)
                                            .foregroundColor(.black)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 3)
                                                    .stroke(Color.gray, lineWidth: 1)
                                            )
                                    }
                                    
                                }
                                .onAppear{
                                    viewModel.getRating()
                                    print(viewModel.user.role)

                                }
                                if viewModel.user.role == "seller" && model.currentUser?.role == "buyer" && !viewModel.ratingOwners.contains(model.userSession?.uid ?? "")
                                {
                                    ZStack{
                                        HStack{
                                            ForEach(1..<6){ index in
                                                Image(systemName: "star.fill")
                                                    .font(.largeTitle)
                                                    .foregroundColor(Int(viewModel.rating) >= index ? Color.yellow : Color.gray)
                                                    .onTapGesture {
                                                        viewModel.rating = Double(index)
                                                        print(viewModel.rating)
                                                    }
                                            }
                                            Button {
                                                viewModel.recordRating(rating: viewModel.rating, userId: viewModel.user.id ?? "")
                                                viewModel.getRating()

                                            } label: {
                                                HStack {
                                                        Image(systemName: "star.square.fill")
                                                        Text("Publish")
                                                }
                                            }.buttonStyle(GradientButtonStyle())
                                            
                                        }
                                    }.padding(.top, 5)
                                }
                            }
                        }
                        Spacer()
                        
                    }.padding(.top)
                }
                
                //PostGridView(config: .profile(user.id ?? ""))
                ProfilePosts(viewModel: ProfileViewModel(user: viewModel.user))
            }
            .padding(.top)
        }.onAppear{
            viewModel.fetchBio()
            viewModel.fetchUserPosts()
            viewModel.fetchUserFollowing()
            viewModel.fetchUserFollowers()
            viewModel.fetchUserPostsAll()
        }
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
