//
//  EndPoint.swift
//  Foody
//
//  Created by Khater on 5/16/23.
//

import Foundation


protocol EndPoint {
    var url: URL? { get }
}



// MARK: - FreeMealDBEndPoint
enum FreeMealDBEndPoint: EndPoint {
    
    static private let baseURL = "https://www.themealdb.com/api/json/v1/1"
    
    case details
    case categories
    case filter
    case list
    case search
    
    public var url: URL? {
        switch self {
        case .details: return URL(string: FreeMealDBEndPoint.baseURL + "/lookup.php")
        case .categories: return URL(string: FreeMealDBEndPoint.baseURL + "/categories.php")
        case .filter: return URL(string: FreeMealDBEndPoint.baseURL + "/filter.php")
        case .list: return URL(string: FreeMealDBEndPoint.baseURL + "/list.php")
        case .search: return URL(string: FreeMealDBEndPoint.baseURL + "/search.php")
        }
    }
}
