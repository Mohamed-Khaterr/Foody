//
//  MealDetailsResponse.swift
//  Foody
//
//  Created by Khater on 6/6/23.
//

import Foundation


struct MealDetailsResponse: Codable {
    let mealsDetails: [MealDetails]
    
    enum CodingKeys: String, CodingKey {
        case mealsDetails = "meals"
    }
}
