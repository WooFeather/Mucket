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
            throw NetworkError.invalidURLError
        }
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        // ResultDTO를 먼저 디코딩해서 에러 코드 확인
        let resultDTO = try JSONDecoder().decode(ResultDTO.self, from: data)
        try handleErrorCode(resultDTO.code ?? "")
        
        do {
            print("🌐 요청 URL: \(request.url?.absoluteString ?? "nil")")
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.encodingError
        }
    }
    
    private func handleErrorCode(_ code: String) throws {
        switch code {
        case "INFO-000":
            return // 정상 처리
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
