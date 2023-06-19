//
//  MealsType.swift
//  Foody
//
//  Created by Khater on 6/18/23.
//

import Foundation


enum MealsType {
    case category(String)
    case country(String)
    
    var value: String {
        switch self {
        case .category(let category): return category
        case .country(let area): return area
        }
    }
}
