//
//  CountriesResponse.swift
//  Foody
//
//  Created by Khater on 6/18/23.
//

import Foundation


struct CountriesResponse: Codable {
    let countries: [Country]
    
    enum CodingKeys: String, CodingKey {
        case countries = "meals"
    }
}
