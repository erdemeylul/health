//
//  FollowersView.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 11.05.2021.
//

import SwiftUI
import Firebase

struct FollowersView: View {
    var user: User

    @State var users = [User]()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Text("Follower List")
                ForEach(users.shuffled()) { user in
                    NavigationLink(
                        destination: LazyView(ProfileView(user: user)),
                        label: {
                            UserCell(user: user)
                                .padding(.leading)
                        })
                }.foregroundColor(Color.primary)
            }
        }.onAppear{
            fetchFollowers()
        }
    }
    
    func fetchFollowers(){
        guard let uid = user.id else {return}
        Firestore.firestore().collection("followers").document(uid).collection("user-followers").getDocuments {snapshot, _ in
            guard let followers = snapshot?.documents.compactMap({ $0.documentID }) else {return}

            print("DEBBUG 1 \(followers)")
            
            for i in followers{
                Firestore.firestore().collection("users").document(i).getDocument { (snapshot, _) in
                    var fol: User?
                    fol = try? snapshot?.data(as: User.self)

                    if fol != nil{
                        print("DEBBUG 2 \(fol!)")

                        self.users.append(fol!)
                        print("DEBBUG 3 \(users)")

                    }
                }
            }
        }
    }
    
}

//struct FollowersView_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowersView()
//    }
//}
