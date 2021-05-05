

import FirebaseFirestoreSwift

struct User: Identifiable, Decodable{
    let email: String
    let profileImageUrl: String
    let role: String
    let username: String
    @DocumentID var id: String?
    
    var bio: String?
    
    var stats: UserStats?
    
    var isFollowed: Bool? = false
    
    var isCurrentUser: Bool { return AuthViewModel.shared.userSession?.uid == id}
}

struct UserStats: Decodable{
    var following: Int
    var posts: Int
    var followers: Int
}
