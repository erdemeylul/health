//
//  RatingDoc.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 2.05.2021.
//

import Foundation

struct RatingDoc: Decodable, Hashable{
    let rating: Int
    let owner: String
}
