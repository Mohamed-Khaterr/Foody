//
//  CustomError.swift
//  Foody
//
//  Created by Khater on 5/16/23.
//

import Foundation


enum CustomError {
    
    enum CoreDataError: LocalizedError {
        case persistentStoresLoading, saveContext
        
        var errorDescription: String? {
            switch self {
            case .persistentStoresLoading: return "Unable to load persistent stores"
            case .saveContext: return "Can't Save current change!"
            }
        }
    }
    
    enum NetworkError: LocalizedError {
        case invalidURL, responseData(Error), responseStatus, encodeParameters, decode(classType: AnyObject)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL: return "Invalide URL!"
            case .responseData(let error): return "Server response with error: \(error.localizedDescription)"
            case .responseStatus: return "The server is not working right now"
            case .encodeParameters: return "Can't encode parameters!"
            case .decode(let classType): return "Can't decode \(String(describing: type(of: classType)))"
            }
        }
    }
}
