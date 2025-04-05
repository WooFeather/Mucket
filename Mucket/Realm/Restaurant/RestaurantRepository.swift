//
//  RestaurantRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

protocol RestaurantRepositoryType {
    func getFileURL()
    func fetchAll() -> [RestaurantEntity]
    func fetch(in folder: RestaurantFolderObject?) -> [RestaurantEntity]
    func add(_ place: RestaurantEntity, folder: RestaurantFolderObject?)
    func update(_ place: RestaurantEntity, folder: RestaurantFolderObject?)
    func delete(id: String)
}

final class RestaurantRepository: RestaurantRepositoryType {
    private let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
    }

    func fetchAll() -> [RestaurantEntity] {
        realm.objects(RestaurantObject.self).map { $0.toEntity() }
    }

    func fetch(in folder: RestaurantFolderObject?) -> [RestaurantEntity] {
        if let folder = folder {
            return realm.objects(RestaurantObject.self).where { $0.folder == folder }.map { $0.toEntity() }
        } else {
            return fetchAll()
        }
    }

    func add(_ place: RestaurantEntity, folder: RestaurantFolderObject?) {
        let object = place.toRealmObject(folder: folder)
        try? realm.write {
            realm.add(object)
        }
    }

    func update(_ place: RestaurantEntity, folder: RestaurantFolderObject?) {
        let object = place.toRealmObject(folder: folder)
        try? realm.write {
            realm.add(object, update: .modified)
        }
    }

    func delete(id: String) {
        guard let objectId = try? ObjectId(string: id),
              let object = realm.object(ofType: RestaurantObject.self, forPrimaryKey: objectId) else { return }

        try? realm.write {
            realm.delete(object)
        }
    }
}
