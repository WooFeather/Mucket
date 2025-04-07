//
//  RestaurantFolderRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/5/25.
//

import Foundation
import RealmSwift

protocol PlaceFolderRepositoryType {
    func getFileURL()
    func fetchAll() -> [PlaceFolderEntity]
    func add(name: String) -> PlaceFolderEntity
    func delete(id: String)
    func getDefaultFolder() -> PlaceFolderEntity
    func getRestaurantObject(by id: String) -> PlaceObject?
    func getRestaurants(inFolderId: String) -> [PlaceEntity]
}

final class PlaceFolderRepository: PlaceFolderRepositoryType {
    
    private let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
    }

    func fetchAll() -> [PlaceFolderEntity] {
        return realm.objects(PlaceFolderObject.self)
            .sorted(byKeyPath: "createdAt")
            .map { $0.toEntity() }
    }

    func add(name: String) -> PlaceFolderEntity {
        let folder = PlaceFolderObject()
        folder.name = name
        try? realm.write {
            realm.add(folder)
        }
        return folder.toEntity()
    }

    func delete(id: String) {
        guard let objectId = try? ObjectId(string: id),
              let folder = realm.object(ofType: PlaceFolderObject.self, forPrimaryKey: objectId) else { return }

        try? realm.write {
            realm.delete(folder)
        }
    }

    func getDefaultFolder() -> PlaceFolderEntity {
        // 기본 폴더가 없으면 생성하고, 있으면 반환
        if let defaultFolder = realm.objects(PlaceFolderObject.self).filter("name == %@", "기본 폴더").first {
            return defaultFolder.toEntity() // 기본 폴더 반환
        } else {
            // 기본 폴더가 없으면 생성해서 저장
            let defaultFolder = PlaceFolderObject()
            defaultFolder.name = "기본 폴더"
            try? realm.write {
                realm.add(defaultFolder)
            }
            return defaultFolder.toEntity() // 새로 생성된 기본 폴더 반환
        }
    }
    
    func getRestaurantObject(by id: String) -> PlaceObject? {
        guard let objId = try? ObjectId(string: id) else { return nil }
        return realm.object(ofType: PlaceObject.self, forPrimaryKey: objId)
    }
    
    func getRestaurants(inFolderId: String) -> [PlaceEntity] {
        guard let objectId = try? ObjectId(string: inFolderId),
              let folder = realm.object(ofType: PlaceFolderObject.self, forPrimaryKey: objectId) else {
            return []
        }
        
        return folder.places.map { $0.toEntity() }
    }
}
