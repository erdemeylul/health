//
//  SearchViewModel.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 23.04.2021.
//

import SwiftUI
import Firebase

class SearchViewModel: ObservableObject{
    
    @Published var users = [User]()
    
    init(){
        fetchUsers()
    }
    
    func fetchUsers(){
        Firestore.firestore().collection("users").whereField("role", isEqualTo: "seller").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {return}
            
            self.users = documents.compactMap ({try? $0.data(as: User.self)})
        }
    }
    
    func filteredUsers(_ query: String)-> [User]{
        let lowercasedQuery = query.lowercased()
        return users.filter({$0.username.lowercased().contains(lowercasedQuery) || $0.city.lowercased().contains(lowercasedQuery)})
    }
}
