//
//  RecipeRouter.swift
//  Mucket
//
//  Created by 조우현 on 4/1/25.
//

import Foundation

enum RouterError: Error, LocalizedError {
    case invalidURLError
    case encodingError
    case networkError(Error)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidURLError:
            return "잘못된 URL"
        case .encodingError:
            return "인코딩 에러"
        case .networkError(let error):
            return "네트워크 에러: \(error.localizedDescription)"
        case .invalidResponse:
            return "유효하지 않은 응답"
        }
    }
}

enum RecipeRouter {
    case fetchAll
    case searchRecipe(String)
    case fetchThemedRecipe(String)
    
    var baseURL: String {
        "https://openapi.foodsafetykorea.go.kr/api"
    }
    
    var apiKey: String {
        APIKeys.recipeAppKey
    }
    
    var endpoint: String {
        return "\(baseURL)/\(apiKey)/COOKRCP01/json/1/1000"
    }
    
    var method: String {
        return "GET"
    }
    
    var headers: [String: String] {
        [:]
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .fetchAll:
            return []
        case .searchRecipe(let ingredient):
            return [URLQueryItem(name: "RCP_PARTS_DTLS", value: ingredient)]
        case .fetchThemedRecipe(let type):
            return [URLQueryItem(name: "RCP_PAT2", value: type)]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard var components = URLComponents(string: endpoint) else {
            throw RouterError.invalidURLError
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw RouterError.invalidURLError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }
}
