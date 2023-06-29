//
//  NetworkManager.swift
//  Foody
//
//  Created by Khater on 5/16/23.
//

import Foundation
import Combine


protocol NetworkManagerType {
    func request<T: Codable>(with request: URLRequest, type: T.Type) -> AnyPublisher<T, CustomError.Network>
    func createURLRequest(endpoint: Endpoint, method: HTTPMethod, parameters: [String: Any]) throws -> URLRequest
}



struct NetworkManager: NetworkManagerType {
    func request<T: Codable>(with request: URLRequest, type: T.Type) -> AnyPublisher<T, CustomError.Network> {
        // Data task Publisher
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global())
            .mapError({ CustomError.Network.noConnectionError($0) })
            .tryMap { output in
                // throw an error if response is nil or statusCode no equal 200
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw CustomError.Network.serverError
                }
                
                
                do {
                    let decodedData = try JSONDecoder().decode(type.self, from: output.data)
                    return decodedData
                } catch {
                    throw CustomError.Network.decodeError(error)
                }
            }
            .mapError({ CustomError.Network.responseFail($0) })
            .eraseToAnyPublisher()
    }
    
    func createURLRequest(endpoint: Endpoint, method: HTTPMethod, parameters: [String: Any]) throws -> URLRequest {
        // Check for URL
        guard let url = endpoint.url else {
            throw CustomError.Network.badURL
        }
        
        // initial Request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add parameter to URL
        switch method {
        case .get:
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = parameters.map({ URLQueryItem(name: $0.key, value: "\($0.value)") })
            request.url = components?.url
            
        case .post, .put, .delete:
            guard let body = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
                throw CustomError.Network.encodeError(parameters)
            }
            request.httpBody = body
        }
        
        return request
    }
}
