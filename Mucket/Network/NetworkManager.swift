//
//  NetworkManager.swift
//  Mucket
//
//  Created by 조우현 on 4/1/25.
//

import Foundation

protocol NetworkManagerType {
    func fetchData<T: Decodable>(_ router: RecipeRouter) async throws -> T
}

final class NetworkManager: NetworkManagerType {
    static let shared: NetworkManagerType = NetworkManager()
    
    private init() { }
    
    func fetchData<T: Decodable>(_ router: RecipeRouter) async throws -> T {
        let request: URLRequest
        do {
            request = try router.asURLRequest()
        } catch {
            throw RouterError.invalidURLError
        }
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw RouterError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw RouterError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw RouterError.encodingError
        }
    }
}
