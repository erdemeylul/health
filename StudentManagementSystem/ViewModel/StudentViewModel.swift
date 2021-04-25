//
//  StudentViewModel.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 18.04.2021.
//




import SwiftUI
import Firebase


class StudentViewModel: ObservableObject{
    @Published var students = [Student]()
    
    
    @Published var userSession: FirebaseAuth.User?

    
    static let shared = AuthViewModel()
    
    init(){
        userSession = Auth.auth().currentUser
    }
    
//    func fetchStudent(schoolName: String, grade: String, classroom: String){
//        Firestore.firestore().collection("schools").document(schoolName).collection(grade).document(classroom).collection("students").getDocuments{ snapshot, _ in
//            guard let documents = snapshot?.documents else {return}
//            self.students = documents.compactMap({ try? $0.data(as: Student.self)})
//        }
//    }
    
    func fetchStudent(schoolName: String,grade: String, classroom: String) {
        Firestore.firestore().collection("schools").document(schoolName).collection(grade).document(classroom).collection("students").addSnapshotListener{querySnapshot, error in
            guard let documents = querySnapshot?.documents else {return}
            
            self.students = documents.map{(queryDocumentSnapshot) -> Student in
                let data = queryDocumentSnapshot.data()
                
                let email = data["email"] as? String ?? ""
                let fullname = data["fullname"] as? String ?? ""
                let no = data["no"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                
                return Student(classroom: classroom, schoolname: schoolName, grade: grade, email: email, fullname: fullname, no: no, image: image)

            }
        }
    }
   
    
    
}
