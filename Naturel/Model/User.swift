

import FirebaseFirestoreSwift

struct User: Identifiable, Decodable, Equatable{
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email && lhs.profileImageUrl == rhs.profileImageUrl && lhs.role == rhs.role && lhs.username == rhs.username && lhs.city == rhs.city
    }
    
    let email: String
    let profileImageUrl: String
    let role: String
    let username: String
    let city: String
    
    @DocumentID var id: String?
    
    var bio: String?
    
    var stats: UserStats?
    
    var isFollowed: Bool? = false
    var unreadMessages: [String:Int]?
    
    var isCurrentUser: Bool { return AuthViewModel.shared.userSession?.uid == id}
}

struct UserStats: Decodable{
    var following: Int
    var posts: Int
    var followers: Int
}
