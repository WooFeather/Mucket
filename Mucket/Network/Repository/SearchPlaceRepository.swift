//
//  SearchPlaceRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/10/25.
//

import Foundation

protocol SearchPlaceRepositoryType {
    func search(query: String, page: Int) async throws -> PlaceEntity
}

final class SearchPlaceRepository: SearchPlaceRepositoryType {
    static let shared: SearchPlaceRepositoryType = SearchPlaceRepository()
    private let networkManager: NetworkManagerType = NetworkManager.shared
    
    private init() { }
    
    func search(query: String, page: Int) async throws -> PlaceEntity {
        do {
            let result: PlaceDTO = try await networkManager.fetchData(PlaceRouter.search(query: query, page: page))
            return result.toEntity()
        } catch {
            throw error
        }
    }
}
