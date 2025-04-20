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
        
        if !(200..<300).contains(httpResponse.statusCode) {
            print("❌ 상태코드: \(httpResponse.statusCode)")
            print("❌ 응답본문: \(String(data: data, encoding: .utf8) ?? "데이터 없음")")
            throw NetworkError.invalidResponse
        }

        // RecipeAPI를 위한 메서드
        try router.decodeErrorIfNeeded(from: data)
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            // 디코딩 에러 내용과, 서버가 준 원본 JSON을 그대로 출력
            print("❌ Decode error:", error)
            if let json = String(data: data, encoding: .utf8) {
                print("❌ Response JSON:\n", json)
            }
            throw NetworkError.decodingError
        }
    }
}
