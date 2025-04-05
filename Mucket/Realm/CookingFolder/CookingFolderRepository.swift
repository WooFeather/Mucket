//
//  FolderRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

protocol CookingFolderRepositoryType {
    func getFileURL()
    func fetchAll() -> [CookingFolderEntity]
    func add(name: String) -> CookingFolderEntity
    func delete(id: String)
    func getDefaultFolder() -> CookingFolderEntity
    func getCookingObject(by id: String) -> MyCookingObject?
    func getMyCookings(inFolderId: String) -> [MyCookingEntity]
}

final class CookingFolderRepository: CookingFolderRepositoryType {
    private let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
    }

    func fetchAll() -> [CookingFolderEntity] {
        return realm.objects(CookingFolderObject.self)
            .sorted(byKeyPath: "createdAt")
            .map { $0.toEntity() }
    }

    func add(name: String) -> CookingFolderEntity {
        let folder = CookingFolderObject()
        folder.name = name
        try? realm.write {
            realm.add(folder)
        }
        return folder.toEntity()
    }

    func delete(id: String) {
        guard let objectId = try? ObjectId(string: id),
              let folder = realm.object(ofType: CookingFolderObject.self, forPrimaryKey: objectId) else { return }

        try? realm.write {
            realm.delete(folder)
        }
    }

    func getDefaultFolder() -> CookingFolderEntity {
        // 기본 폴더가 없으면 생성하고, 있으면 반환
        if let defaultFolder = realm.objects(CookingFolderObject.self).filter("name == %@", "기본 폴더").first {
            return defaultFolder.toEntity() // 기본 폴더 반환
        } else {
            // 기본 폴더가 없으면 생성해서 저장
            let defaultFolder = CookingFolderObject()
            defaultFolder.name = "기본 폴더"
            try? realm.write {
                realm.add(defaultFolder)
            }
            return defaultFolder.toEntity() // 새로 생성된 기본 폴더 반환
        }
    }
    
    func getCookingObject(by id: String) -> MyCookingObject? {
        guard let objId = try? ObjectId(string: id) else { return nil }
        return realm.object(ofType: MyCookingObject.self, forPrimaryKey: objId)
    }
    
    func getMyCookings(inFolderId: String) -> [MyCookingEntity] {
        guard let objectId = try? ObjectId(string: inFolderId),
              let folder = realm.object(ofType: CookingFolderObject.self, forPrimaryKey: objectId) else {
            return []
        }
        
        return folder.cookings.map { $0.toEntity() }
    }
}
