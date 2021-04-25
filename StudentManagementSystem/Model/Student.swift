//
//  Student.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 18.04.2021.
//

import FirebaseFirestoreSwift
import SwiftUI

struct Student: Codable, Identifiable{
    let classroom: String
    let schoolname: String
    let grade: String
    let email: String
    let fullname: String
    let no: String
    let image: String
    @DocumentID var id: String?
    
}
//
//struct Parents: Codable{
//    let parent1: String
//    let parent2: String
//    let parent3: String
//    let parent4: String
//}
//
//struct Classes: Codable{
//    let class1: String
//    let class2: String
//    let class3: String
//    let class4: String
//    let class5: String
//    let class6: String
//    let class7: String
//    let class8: String
//    let class9: String
//    let class10: String
//    let class11: String
//    let class12: String
//}
//
//struct TeacherNotes: Codable{
//    let strengths: String
//    let weaknesses: String
//    let suggestions: String
//    let sources: String
//}
//
//struct Class: Codable{
//    let exam1: String
//    let exam2: String
//    let exam3: String
//    let exam4: String
//    let nextExamDate: Date
//    let sources: String
//    let tests:[Test]
//    let quiz: [Quiz]
//    let quizMean: Int
//
//
//}
//
//struct Test: Codable{
//
//}
//
//struct Quiz: Codable{
//
//}
