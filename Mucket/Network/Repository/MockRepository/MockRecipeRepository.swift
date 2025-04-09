//
//  MockRecipeRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/1/25.
//

import Foundation

final class MockRecipeRepository: RecipeRepositoryType {
    
    private let mockData: [RecipeEntity]
    
    init(mockData: [RecipeEntity] = RecipeEntity.mockList) {
        self.mockData = mockData
    }
    
    func fetchAll() async throws -> [RecipeEntity] {
        return mockData
    }
    
    func search(startIndex: Int, count: Int, byName name: String) async throws -> [RecipeEntity] {
        return mockData.filter { $0.name.contains(name) }
    }
    
    func fetchTheme(type: String) async throws -> [RecipeEntity] {
        return mockData.filter { _ in Bool.random() } // 랜덤하게 반환
    }
}
