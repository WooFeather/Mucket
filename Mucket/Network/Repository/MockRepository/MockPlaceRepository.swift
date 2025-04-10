//
//  MockPlaceRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/10/25.
//

import Foundation

final class MockPlaceRepository: SearchPlaceRepositoryType {
    
    private let mockData: PlaceEntity
    
    init(mockData: PlaceEntity = PlaceEntity.mockData) {
        self.mockData = mockData
    }
    
    func search(query: String, page: Int) async throws -> PlaceEntity {
        return mockData
    }
}
