//
//  SearchResponse.swift
//  Foody
//
//  Created by Khater on 6/24/23.
//

import Foundation


struct SearchResponse: Codable {
    let mealsDetails: [MealDetails]?
    
    enum CodingKeys: String, CodingKey {
        case mealsDetails = "meals"
    }
}
