//
//  MyCookingRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

protocol MyCookingRepositoryType {
    func getFileURL()
    func fetchAll() -> [MyCookingObject]
    func fetch(in folder: FolderObject?) -> [MyCookingObject]
    func add(_ cooking: MyCookingObject)
    func update(_ cooking: MyCookingObject)
    func delete(_ cooking: MyCookingObject)
}

final class MyCookingRepository: MyCookingRepositoryType {
    private let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
    }

    func fetchAll() -> [MyCookingObject] {
        Array(realm.objects(MyCookingObject.self))
    }

    func fetch(in folder: FolderObject?) -> [MyCookingObject] {
        if let folder = folder {
            return Array(realm.objects(MyCookingObject.self).where { $0.folder == folder })
        } else {
            return fetchAll()
        }
    }

    func add(_ cooking: MyCookingObject) {
        try? realm.write {
            realm.add(cooking)
        }
    }

    func update(_ cooking: MyCookingObject) {
        try? realm.write {
            realm.add(cooking, update: .modified)
        }
    }

    func delete(_ cooking: MyCookingObject) {
        try? realm.write {
            realm.delete(cooking)
        }
    }
}
