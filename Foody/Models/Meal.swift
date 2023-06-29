//
//  Meal.swift
//  Foody
//
//  Created by Khater on 5/16/23.
//

import Foundation


struct Meal: Codable {
    let id: String
    let name: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case image = "strMealThumb"
    }
}
