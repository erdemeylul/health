

import Firebase


class FeedViewModel: ObservableObject{
    @Published var posts = [Post]()
    @Published var users: [String] = []
    
    static let shared = FeedViewModel()

    
    
    init(){
        //fetchPosts()
        fetchFollowers()
        //fetchFollowingPosts()
    }
    
    func fetchPosts(){
        Firestore.firestore().collection("posts").order(by: "timestamp", descending: true).limit(to: 50).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {return}
            self.posts = documents.compactMap({try? $0.data(as: Post.self)})
        }
    }
    
    func fetchFollowers(){
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        Firestore.firestore().collection("following").document(uid).collection("user-following").getDocuments { (snapshot, _) in
            guard let documents = snapshot?.documents else {return}

            self.users = documents.compactMap({ $0.documentID })
            self.users.append(uid)
            print("DEBUG \(self.users)")
            if self.users.count > 0 {
                Firestore.firestore().collection("posts").order(by: "timestamp", descending: true).limit(to: 50).whereField("ownerUid", in: self.users).getDocuments { (snapshot, _) in
                    guard let documents = snapshot?.documents else {return print("no users")}
                    self.posts = documents.compactMap({try? $0.data(as: Post.self)})
                }
            }
        }
    }
    
//    func fetchFollowingPosts(){
//        if self.users.count > 0{
//            Firestore.firestore().collection("posts").whereField("ownerUid", in: self.users).getDocuments { (snapshot, _) in
//                guard let documents = snapshot?.documents else {return print("no users")}
//                self.posts = documents.compactMap({try? $0.data(as: Post.self)})
//                print(self.posts)
//                print("hehe")
//            }
//        }else{
//            print("")
//        }
//    }
    
    
}
