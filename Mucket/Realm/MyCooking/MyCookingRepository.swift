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
    func fetch(in folder: MyCookingFolderObject?) -> [MyCookingObject]
    func add(_ cooking: MyCookingEntity, folder: MyCookingFolderObject)
    func update(_ cooking: MyCookingEntity)
    func delete(id: String)
}

final class MyCookingRepository: MyCookingRepositoryType {
    
    private let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
    }

    func fetchAll() -> [MyCookingObject] {
        let data = realm.objects(MyCookingObject.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
        
        return Array(data)
    }

    func fetch(in folder: MyCookingFolderObject?) -> [MyCookingObject] {
        if let folder = folder {
            return Array(realm.objects(MyCookingObject.self).where { $0.myCookingFolder == folder })
        } else {
            return fetchAll()
        }
    }

    func add(_ cooking: MyCookingEntity, folder: MyCookingFolderObject) {
        let object = cooking.toRealmObject()
        do {
            try realm.write {
                realm.add(object)
                folder.myCookingObject.append(object)
            }
        } catch {
            print("Realm 데이터 저장 실패")
        }
    }

    func update(_ cooking: MyCookingEntity) {
        let object = cooking.toRealmObject()
        try? realm.write {
            realm.add(object, update: .modified)
        }
    }

    func delete(id: String) {
        guard let objectId = try? ObjectId(string: id),
              let object = realm.object(ofType: MyCookingObject.self, forPrimaryKey: objectId) else { return }
        
        try? realm.write {
            realm.delete(object)
        }
    }
}
