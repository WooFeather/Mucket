//
//  Router.swift
//  Mucket
//
//  Created by 조우현 on 4/9/25.
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

protocol Router {
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String] { get }
    var queryParameters: [URLQueryItem]? { get }
    var body: Data? { get }

    func asURLRequest() throws -> URLRequest
    
    /// 응답 데이터에서 에러 코드를 파싱하고 필요시 에러를 throw
    func decodeErrorIfNeeded(from data: Data) throws
}


extension Router {
    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            throw RouterError.invalidURLError
        }

        urlComponents.queryItems = queryParameters
        
        guard let url = urlComponents.url else {
            throw RouterError.invalidURLError
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        return request
    }
}

extension Router {
    func decodeErrorIfNeeded(from data: Data) throws {
        // RecipeAPI를 위한 메서드 (처리는 RecipeRoter 내에서)
    }
}
