//
//  FolderRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

protocol FolderRepositoryType {
    func getFileURL()
    func fetchAll() -> [FolderEntity]
    func add(name: String) -> FolderEntity
    func delete(id: String)
    func getDefaultFolder() -> FolderEntity
}

final class FolderRepository: FolderRepositoryType {
    private let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
    }

    func fetchAll() -> [FolderEntity] {
        return realm.objects(FolderObject.self)
            .sorted(byKeyPath: "createdAt")
            .map { $0.toEntity() }
    }

    func add(name: String) -> FolderEntity {
        let folder = FolderObject()
        folder.name = name
        try? realm.write {
            realm.add(folder)
        }
        return folder.toEntity()
    }

    func delete(id: String) {
        guard let objectId = try? ObjectId(string: id),
              let folder = realm.object(ofType: FolderObject.self, forPrimaryKey: objectId) else { return }

        try? realm.write {
            realm.delete(folder)
        }
    }

    func getDefaultFolder() -> FolderEntity {
        if let defaultFolder = realm.objects(FolderObject.self).filter("name == %@", "기본 폴더").first {
            return defaultFolder.toEntity()
        } else {
            return add(name: "기본 폴더")
        }
    }
}
