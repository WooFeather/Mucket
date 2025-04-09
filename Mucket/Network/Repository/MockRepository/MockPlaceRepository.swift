//
//  MockPlaceRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/10/25.
//

import Foundation

final class MockPlaceRepository: SearchPlaceRepositoryType {
    
    private let mockData: SearchPlaceEntity
    
    init(mockData: SearchPlaceEntity = SearchPlaceEntity.mockData) {
        self.mockData = mockData
    }
    
    func search(query: String, page: Int) async throws -> SearchPlaceEntity {
        return mockData
    }
}
