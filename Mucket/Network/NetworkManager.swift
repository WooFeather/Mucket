//
//  NetworkManager.swift
//  Mucket
//
//  Created by 조우현 on 4/1/25.
//

import Foundation

protocol NetworkManagerType {
    func fetchData<T: Decodable>(_ router: Router) async throws -> T
}

final class NetworkManager: NetworkManagerType {
    static let shared: NetworkManagerType = NetworkManager()
    
    private init() {}

    func fetchData<T: Decodable>(_ router: Router) async throws -> T {
        let request: URLRequest
        do {
            request = try router.asURLRequest()
        } catch {
            throw NetworkError.invalidURLError
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        // RecipeAPI를 위한 메서드
        try router.decodeErrorIfNeeded(from: data)

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.encodingError
        }
    }
}
