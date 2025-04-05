//
//  RecipeRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/1/25.
//

import Foundation

protocol RecipeRepositoryType {
    func fetchAll() async throws -> [RecipeEntity]
    func search(startIndex: Int, count: Int, byName name: String) async throws -> [RecipeEntity]
    func fetchTheme(type: String) async throws -> [RecipeEntity]
}

final class RecipeRepository: RecipeRepositoryType {
    static let shared: RecipeRepositoryType = RecipeRepository()
    private let networkManager: NetworkManagerType = NetworkManager.shared
    
    private init() { }
    
    func fetchAll() async throws -> [RecipeEntity] {
        do {
            let result: RecipeDTO = try await networkManager.fetchData(.fetchAll)
            return result.recipeInfo.row.map { $0.toEntity() }
        } catch {
            throw error
        }
    }
    
    func search(startIndex: Int, count: Int, byName name: String) async throws -> [RecipeEntity] {
        do {
            let result: RecipeDTO = try await networkManager.fetchData(.searchRecipe(startIndex: startIndex, count: count, name: name))
            return result.recipeInfo.row.map { $0.toEntity() }
        } catch {
            throw error
        }
    }
    
    func fetchTheme(type: String) async throws -> [RecipeEntity] {
        do {
            let result: RecipeDTO = try await networkManager.fetchData(.fetchThemedRecipe(type: type))
            return result.recipeInfo.row.map { $0.toEntity() }
        } catch {
            throw error
        }
    }
}
