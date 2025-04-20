//
//  RecipeRouter.swift
//  Mucket
//
//  Created by 조우현 on 4/1/25.
//

import Foundation

enum RecipeRouter: Router {
    case fetchAll
    case searchRecipe(startIndex: Int, count: Int, name: String)
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
        case .searchRecipe(let startIndex, let count, let name):
            return "/\(apiKey)/COOKRCP01/json/\(startIndex)/\(count)/RCP_NM=\(name)"
        case .fetchThemedRecipe(let type):
            return "/\(apiKey)/COOKRCP01/json/1/1000/RCP_PAT2=\(type)"
        }
    }

    var method: String {
        "GET"
    }

    var headers: [String: String] {
        [:]
    }

    var queryParameters: [URLQueryItem]? {
        switch self {
        case .fetchAll:
            return nil
        case .searchRecipe:
            return nil
        case .fetchThemedRecipe(_):
            return nil
        }
    }

    var body: Data? {
        nil
    }
}

extension RecipeRouter {
    func decodeErrorIfNeeded(from data: Data) throws {
        let resultDTO = try JSONDecoder().decode(ResultDTO.self, from: data)
        let code = resultDTO.code ?? ""
        
        switch code {
        case "INFO-000":
            return
        case "ERROR-300":
            throw NetworkError.noDataError
        case "ERROR-301":
            throw NetworkError.invalidParameterTypeError
        case "ERROR-310":
            throw NetworkError.serviceNotFoundError
        case "ERROR-331":
            throw NetworkError.startIndexNotFoundError
        case "ERROR-332":
            throw NetworkError.endIndexNotFoundError
        case "ERROR-334":
            throw NetworkError.tooManyRequestsError
        case "ERROR-336":
            throw NetworkError.dataLimitExceededError
        case "ERROR-500":
            throw NetworkError.serverError
        case "ERROR-601":
            throw NetworkError.sqlError
        case "INFO-100":
            throw NetworkError.infoNoData
        case "INFO-200":
            throw NetworkError.infoDataExists
        case "INFO-300":
            throw NetworkError.infoDataUpdated
        case "INFO-400":
            throw NetworkError.infoNoPermission
        default:
            return
        }
    }
}
