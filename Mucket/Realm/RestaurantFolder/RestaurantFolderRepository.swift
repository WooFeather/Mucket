//
//  RestaurantFolderRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/5/25.
//

import Foundation
import RealmSwift

protocol RestaurantFolderRepositoryType {
    func getFileURL()
    func fetchAll() -> [RestaurantFolderEntity]
    func add(name: String) -> RestaurantFolderEntity
    func delete(id: String)
    func getDefaultFolder() -> RestaurantFolderEntity
    func getRestaurantObject(by id: String) -> RestaurantObject?
    func getRestaurants(inFolderId: String) -> [RestaurantEntity]
}

final class RestaurantFolderRepository: RestaurantFolderRepositoryType {
    
    private let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
    }

    func fetchAll() -> [RestaurantFolderEntity] {
        return realm.objects(RestaurantFolderObject.self)
            .sorted(byKeyPath: "createdAt")
            .map { $0.toEntity() }
    }

    func add(name: String) -> RestaurantFolderEntity {
        let folder = RestaurantFolderObject()
        folder.name = name
        try? realm.write {
            realm.add(folder)
        }
        return folder.toEntity()
    }

    func delete(id: String) {
        guard let objectId = try? ObjectId(string: id),
              let folder = realm.object(ofType: RestaurantFolderObject.self, forPrimaryKey: objectId) else { return }

        try? realm.write {
            realm.delete(folder)
        }
    }

    func getDefaultFolder() -> RestaurantFolderEntity {
        // 기본 폴더가 없으면 생성하고, 있으면 반환
        if let defaultFolder = realm.objects(RestaurantFolderObject.self).filter("name == %@", "기본 폴더").first {
            return defaultFolder.toEntity() // 기본 폴더 반환
        } else {
            // 기본 폴더가 없으면 생성해서 저장
            let defaultFolder = RestaurantFolderObject()
            defaultFolder.name = "기본 폴더"
            try? realm.write {
                realm.add(defaultFolder)
            }
            return defaultFolder.toEntity() // 새로 생성된 기본 폴더 반환
        }
    }
    
    func getRestaurantObject(by id: String) -> RestaurantObject? {
        guard let objId = try? ObjectId(string: id) else { return nil }
        return realm.object(ofType: RestaurantObject.self, forPrimaryKey: objId)
    }
    
    func getRestaurants(inFolderId: String) -> [RestaurantEntity] {
        guard let objectId = try? ObjectId(string: inFolderId),
              let folder = realm.object(ofType: RestaurantFolderObject.self, forPrimaryKey: objectId) else {
            return []
        }
        
        return folder.restaurants.map { $0.toEntity() }
    }
}
