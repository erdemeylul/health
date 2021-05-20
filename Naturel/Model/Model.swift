//
//  Model.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 29.04.2021.
//

import Foundation


enum MessageType: String, Decodable{
    case sent
    case received
}

struct Message: Hashable, Decodable {
    var id: String?
    let text: String
    let type: MessageType
    let created: Date
    let read: Bool
}

struct Mess:  Identifiable, Hashable, Decodable{
    var id: String?
    let text: String
    let sender: String
    let created: String
    let read: Bool
}


