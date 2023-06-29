//
//  MealDetails.swift
//  Foody
//
//  Created by Khater on 6/6/23.
//

import Foundation


struct MealDetails: Codable {
    let id: String
    let name: String
    let category: String
    let area: String
    let instructions: String
    let image: String
    let tags: String?
    let youtubeVideo: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case image = "strMealThumb"
        case tags = "strTags"
        case youtubeVideo = "strYoutube"
    }
}
