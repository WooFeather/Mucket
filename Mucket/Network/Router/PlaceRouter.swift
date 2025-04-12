//
//  PlaceRouter.swift
//  Mucket
//
//  Created by 조우현 on 4/10/25.
//

import Foundation

enum PlaceRouter: Router {
    case search(query: String, page: Int)
    
    var baseURL: String {
        "https://dapi.kakao.com/v2/local/"
    }
    
    var apiKey: String {
        APIKeys.kakaoRESTAPIKey
    }
    
    var path: String {
        switch self {
        case .search(_, _):
            return "search/keyword.json"
        }
    }
    
    
    var method: String {
        "GET"
    }
    
    var headers: [String : String] {
        ["Authorization": "KakaoAK \(APIKeys.kakaoRESTAPIKey)"]
    }
    
    var queryParameters: [URLQueryItem]? {
        switch self {
        case .search(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                // URLQueryItem(name: "category_group_code", value: "FD6"), 1.1.1 카테고리제한 해제
                URLQueryItem(name: "page", value: String(page))
            ]
        }
    }
    
    var body: Data? {
        nil
    }
}
