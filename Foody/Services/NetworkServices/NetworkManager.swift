//
//  NetworkManager.swift
//  Foody
//
//  Created by Khater on 5/16/23.
//

import Foundation


class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Codable>(endpoint: EndPoint, method: HTTPMethod, parameters: [String: Any], type: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw CustomError.NetworkError.invalidURL
        }
        
        // initial Requestb
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
                throw CustomError.NetworkError.encodeParameters
            }
            request.httpBody = body
        }
        
        // Send request and get response
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try JSONDecoder().decode(type, from: data)
            return decodedData
        } catch {
            throw error
        }
    }
}
