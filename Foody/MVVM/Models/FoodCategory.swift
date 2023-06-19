//
//  FoodCategory.swift
//  Foody
//
//  Created by Khater on 5/13/23.
//

import Foundation


struct FoodCategory: Codable {
    let id: String
    let name: String
    let description: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case description = "strCategoryDescription"
        case image = "strCategoryThumb"
    }
}
