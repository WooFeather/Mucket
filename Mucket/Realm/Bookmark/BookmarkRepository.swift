//
//  BookmarkRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

protocol BookmarkedRecipeRepositoryType {
    func getFileURL()
    func fetchAll() -> [RecipeEntity]
    func save(_ recipe: RecipeEntity)
    func delete(by id: String)
    func isBookmarked(id: String) -> Bool
}


final class BookmarkedRecipeRepository: BookmarkedRecipeRepositoryType {
    private let realm = try! Realm()

    func getFileURL() {
        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
    }
    
    func fetchAll() -> [RecipeEntity] {
        let objects = realm.objects(BookmarkedRecipeObject.self)
        return objects.map { $0.toEntity() }
    }

    func save(_ recipe: RecipeEntity) {
        let object = recipe.toRealmObject()
        try? realm.write {
            realm.add(object, update: .modified)
        }
    }

    func delete(by id: String) {
        if let object = realm.object(ofType: BookmarkedRecipeObject.self, forPrimaryKey: id) {
            try? realm.write {
                realm.delete(object)
            }
        }
    }

    func isBookmarked(id: String) -> Bool {
        return realm.object(ofType: BookmarkedRecipeObject.self, forPrimaryKey: id) != nil
    }
}
