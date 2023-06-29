//
//  CustomError.swift
//  Foody
//
//  Created by Khater on 5/16/23.
//

import Foundation


enum CustomError {
    
    enum CoreData: LocalizedError {
        case persistentStoresError, contextError
        
        var errorDescription: String? {
            switch self {
            case .persistentStoresError: return "Unable to load persistent stores"
            case .contextError: return "Can't Save current change!"
            }
        }
    }
    
    enum Network: LocalizedError {
        case badURL, responseFail(_ error: Error), noConnectionError(_ error: Error), serverError, encodeError(_ parameters: [String:Any]), decodeError(_ error: Error)
        
        var errorDescription: String? {
            switch self {
            case .badURL: return "Bad url!"
            case .responseFail(let error): return "Response Fail with error: \(error.localizedDescription)"
            case .noConnectionError(let error): return "Connection fail \(error.localizedDescription)"
            case .serverError: return "The server is not working right now"
            case .encodeError(let parameters): return "Can't encode parameters: \(parameters.description)"
            case .decodeError(let error): return "Can't decode \(error.localizedDescription)"
            }
        }
    }
}
