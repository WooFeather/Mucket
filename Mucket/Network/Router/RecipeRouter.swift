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
    case searchRecipe(startIndex: Int, count: Int, ingredient: String)
    case fetchThemedRecipe(type: String)
    
    var baseURL: String {
        "https://openapi.foodsafetykorea.go.kr/api"
    }
    
    var apiKey: String {
        APIKeys.recipeAppKey
    }
    
    var path: String {
        switch self {
        case .fetchAll:
            return "/\(apiKey)/COOKRCP01/json/1/1000"
        case .searchRecipe(let startIndex, let count, let ingredient):
            return "/\(apiKey)/COOKRCP01/json/\(startIndex)/\(count)/RCP_PARTS_DTLS=\(ingredient.urlEncoded)"
        case .fetchThemedRecipe(let type):
            return "/\(apiKey)/COOKRCP01/json/1/1000/RCP_PAT2=\(type.urlEncoded)"
        }
    }
    
    var method: String {
        "GET"
    }
    
    var headers: [String: String] {
        [:]
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw RouterError.invalidURLError
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }
}
