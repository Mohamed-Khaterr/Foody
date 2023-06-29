//
//  Country.swift
//  Foody
//
//  Created by Khater on 6/5/23.
//

import Foundation


struct Country: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strArea"
    }
}
