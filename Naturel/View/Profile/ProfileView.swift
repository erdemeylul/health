

import SwiftUI
import URLImage


struct ProfileView: View {
    let user: User
    var uid: String?
    @ObservedObject var viewModel: ProfileViewModel
    
    @Environment(\.colorScheme) var colorScheme

    
    @EnvironmentObject var model: AuthViewModel
    var isFollowed: Bool { return viewModel.user.isFollowed ?? false }
    @State var showEditProfile = false
    @State var otherUsername = ""
    @State var show = false
    
    @State private var selectedImage: UIImage?
    @State private var image: Image?
    
    @State var point = false
    
    @State var imagePickerPresented = false
    @State var sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
    
    
    init(user: User) {
        self.user = user
        self.viewModel = ProfileViewModel(user: user)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(alignment: .leading) {
                    HStack {

                        if let image = image{
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .padding(.leading)
                                .onTapGesture {
                                    if AuthViewModel.shared.currentUser?.id == user.id {
                                        imagePickerPresented = true
                                    }
                                }.sheet(isPresented: $imagePickerPresented, onDismiss:loadImage, content: {
                                    ImagePicker(image: $selectedImage, sourceType: $sourceType)
                                })
                         
                        }else {
                            URLImage(url: URL(string: viewModel.user.profileImageUrl)!) {image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .padding(.leading)
                            }.onTapGesture {
                                if AuthViewModel.shared.currentUser?.id == user.id {
                                    imagePickerPresented = true
                                }
                            }.sheet(isPresented: $imagePickerPresented, onDismiss:loadImage, content: {
                                ImagePicker(image: $selectedImage, sourceType: $sourceType)
                            })
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            UserStatView(value: viewModel.posts, title1: "", title2: "Paylaşimlar")
                            
                            NavigationLink(destination: FollowersView(user: viewModel.user)) {
                                UserStatView(value: viewModel.followers, title1: "Takip", title2:"Edenler").foregroundColor(Color.primary)
                            }
                            
                            NavigationLink(destination: FollowingView(user: viewModel.user)) {
                                UserStatView(value: viewModel.following, title1: "Takip", title2:" Edilenler").foregroundColor(Color.primary)
                            }
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
                            .foregroundColor(.primary)
                    }
                     
                    HStack {
                        Spacer()
                        
                        //ProfileActionButtonView(viewModel: viewModel)
                        if viewModel.user.isCurrentUser {
                            Button(action: { showEditProfile.toggle() }, label: {
                                Text("Bilgiyi Güncelleyin")
                                    .padding(20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.neuBackground)
                                        )
                                    .foregroundColor(Color("koyuyesil"))
                            }).sheet(isPresented: $showEditProfile) {
                                //EditProfileView(user: $viewModel.user)
                                EditBio(viewModel: ProfileViewModel(user: viewModel.user), bioText: $viewModel.bio)
                            }
                            
                        } else {
                            VStack{
                                HStack{
                                    Spacer()
                                    if viewModel.user.role == "üretici" {
                                        if viewModel.ratingMean.count > 0 {
                                            ZStack{
                                                Circle()
                                                    .foregroundColor(Color("arkaplan"))
                                                    .frame(width: 60, height: 60)
                                                Text("\(Double(Double(viewModel.total) / Double(viewModel.ratingMean.count)).rounded(toPlaces: 1).removeZerosFromEnd())")
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.orange)
                                                    .font(.system(size: 38))
                                            }
                                            Image(systemName: "star.fill")
                                                .foregroundColor(Color.yellow)
                                                .font(.system(size: 40))
                                        }else{
                                            Text("Puanlama Yok")
                                        }
                                    }
                                    Spacer()
                                }.padding(.bottom)
                                
                                HStack {
                                    Button(action: { isFollowed ? viewModel.unFollow() : viewModel.follow() }, label: {
                                        Text(isFollowed ? "Takip ediliyor" : "Takip et")
                                            .font(.system(size: 14, weight: .semibold))
                                            .frame(width: 172, height: 32)
                                            .foregroundColor(isFollowed ? .black : .white)
                                            .background(isFollowed ? Color("krem") : Color("koyuyesil"))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 3)
                                                    .stroke(Color.gray, lineWidth: isFollowed ? 1 : 0)
                                            )
                                    }).cornerRadius(3)

                                    NavigationLink(destination: ChatView(otherUsername: viewModel.user.id ?? "")) {
                                        Text("Mesaj")
                                            .font(.system(size: 14, weight: .semibold))
                                            .frame(width: 172, height: 32)
                                            .foregroundColor(.primary)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 3)
                                                    .stroke(Color.gray, lineWidth: 1)
                                            )
                                    }
                                    
                                }
                                .onAppear{
                                    viewModel.getRating()
                                }
                                if viewModel.user.role == "üretici" && model.currentUser?.role == "tüketici" && !viewModel.ratingOwners.contains(model.userSession?.uid ?? "")
                                {
                                    ZStack{
                                        HStack{
                                            ForEach(1..<6){ index in
                                                Image(systemName: "star.fill")
                                                    .font(.largeTitle)
                                                    .foregroundColor(Int(viewModel.rating) >= index ? Color.yellow : Color.gray)
                                                    .onTapGesture {
                                                        viewModel.rating = Double(index)
                                                        point = true
                                                    }
                                            }
                                            Button {
                                                if point{
                                                    viewModel.recordRating(rating: viewModel.rating, userId: viewModel.user.id ?? "")
                                                    viewModel.getRating()
                                                }
                                            } label: {
                                                HStack {
                                                        Image(systemName: "star.square.fill")
                                                        Text("Puan ver")
                                                            .foregroundColor(Color("koyuyesil"))
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
                
                ProfilePosts(viewModel: ProfileViewModel(user: viewModel.user))
            }
            .padding(.top)
        }.onAppear{
            if AuthViewModel.shared.finBio{
                viewModel.fetchBio()
            }
            viewModel.fetchUserFollowing()
            viewModel.fetchUserFollowers()
            if AuthViewModel.shared.finPic{
                print("\(AuthViewModel.shared.finPic)")
                viewModel.fetchUserPostsAll()
                viewModel.fetchUserPosts()
            }
            AuthViewModel.shared.finPic = false
            AuthViewModel.shared.finBio = false

            print("\(AuthViewModel.shared.finPic)")
        }
    }
}

extension ProfileView {
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        image = Image(uiImage: selectedImage)
        viewModel.changePic(image: selectedImage)
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

extension Color {
    static let neuBackground = Color(hex: "f0f0f3")
    static let dropShadow = Color(hex: "aeaec0").opacity(0.4)
    static let dropLight = Color(hex: "ffffff")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = scanner.string.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
