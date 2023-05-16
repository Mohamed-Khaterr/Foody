//
//  AppError.swift
//  Foody
//
//  Created by Khater on 5/16/23.
//

import Foundation


enum AppError: LocalizedError {
    case invalidURL, encodeParameters
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalide URL!"
        case .encodeParameters: return "Can't encode parameters!"
        }
    }
}
