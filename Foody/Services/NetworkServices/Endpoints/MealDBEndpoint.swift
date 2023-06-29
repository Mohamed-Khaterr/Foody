//
//  MealDBEndpoint.swift
//  Foody
//
//  Created by Khater on 6/20/23.
//

import Foundation


enum MealDBEndpoint: Endpoint {
    
    static private let baseURL = "https://www.themealdb.com/api/json/v1/1"
    
    case details
    case categories
    case filter
    case list
    case search
    
    public var url: URL? {
        switch self {
        case .details: return URL(string: MealDBEndpoint.baseURL + "/lookup.php")
        case .categories: return URL(string: MealDBEndpoint.baseURL + "/categories.php")
        case .filter: return URL(string: MealDBEndpoint.baseURL + "/filter.php")
        case .list: return URL(string: MealDBEndpoint.baseURL + "/list.php")
        case .search: return URL(string: MealDBEndpoint.baseURL + "/search.php")
        }
    }
}
