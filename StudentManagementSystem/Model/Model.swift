//
//  Model.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 29.04.2021.
//

import Foundation


enum MessageType: String{
    case sent
    case received
}

struct Message: Hashable {
    var id: String?
    let text: String
    let type: MessageType
    let created: Date
}
