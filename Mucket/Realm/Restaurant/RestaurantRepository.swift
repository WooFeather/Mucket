//
//  RestaurantRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

//protocol PlaceRepositoryType {
//    func getFileURL()
//    func fetchAll() -> [PlaceEntity]
//    func fetch(in folder: FolderObject?) -> [PlaceEntity]
//    func add(_ place: PlaceEntity, folder: FolderObject?)
//    func update(_ place: PlaceEntity, folder: FolderObject?)
//    func delete(id: String)
//}
//
//final class PlaceRepository: PlaceRepositoryType {
//    private let realm = try! Realm()
//    
//    func getFileURL() {
//        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
//    }
//
//    func fetchAll() -> [PlaceEntity] {
//        realm.objects(PlaceObject.self).map { $0.toEntity() }
//    }
//
//    func fetch(in folder: FolderObject?) -> [PlaceEntity] {
//        if let folder = folder {
//            return realm.objects(PlaceObject.self).where { $0.folder == folder }.map { $0.toEntity() }
//        } else {
//            return fetchAll()
//        }
//    }
//
//    func add(_ place: PlaceEntity, folder: FolderObject?) {
//        let object = place.toRealmObject(folder: folder)
//        try? realm.write {
//            realm.add(object)
//        }
//    }
//
//    func update(_ place: PlaceEntity, folder: FolderObject?) {
//        let object = place.toRealmObject(folder: folder)
//        try? realm.write {
//            realm.add(object, update: .modified)
//        }
//    }
//
//    func delete(id: String) {
//        guard let objectId = try? ObjectId(string: id),
//              let object = realm.object(ofType: PlaceObject.self, forPrimaryKey: objectId) else { return }
//
//        try? realm.write {
//            realm.delete(object)
//        }
//    }
//}
