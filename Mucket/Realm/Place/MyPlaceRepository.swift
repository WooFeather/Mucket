//
//  RestaurantRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

protocol MyPlaceRepositoryType {
    func getFileURL()
    func fetchAll() -> [MyPlaceEntity]
    func fetch(in folderId: String?) -> [MyPlaceEntity]
    func add(_ entity: MyPlaceEntity, toFolderId folderId: String?)
    func update(_ entity: MyPlaceEntity)
    func delete(id: String)
    func fetchById(_ id: String) -> MyPlaceObject?
}

final class MyPlaceRepository: MyPlaceRepositoryType {
    private let realm = try! Realm()
    private let folderRepository = PlaceFolderRepository()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
    }

    func fetchAll() -> [MyPlaceEntity] {
        return realm.objects(MyPlaceObject.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .map { $0.toEntity() }
    }

    func fetch(in folderId: String?) -> [MyPlaceEntity] {
        if let folderId = folderId,
           let objectId = try? ObjectId(string: folderId),
           let folder = realm.object(ofType: PlaceFolderObject.self, forPrimaryKey: objectId) {
            return folder.places.map { $0.toEntity() }
        } else {
            return fetchAll()
        }
    }

    func add(_ entity: MyPlaceEntity, toFolderId folderId: String? = nil) {
        let realmObject = entity.toRealmObject()
        
        try? realm.write {
            realm.add(realmObject)
            
            let folderObjectId: ObjectId?
            if let folderId = folderId {
                folderObjectId = try? ObjectId(string: folderId)
            } else {
                let defaultFolder = folderRepository.getDefaultFolder()
                folderObjectId = try? ObjectId(string: defaultFolder.id)
            }
            
            if let folderObjectId = folderObjectId,
               let folder = realm.object(ofType: PlaceFolderObject.self, forPrimaryKey: folderObjectId) {
                folder.places.append(realmObject)
            }
        }
    }

    func update(_ entity: MyPlaceEntity) {
        let realmObject = entity.toRealmObject()
        
        try? realm.write {
            realm.add(realmObject, update: .modified)
            
            if let folderId = entity.folderId,
               let objectId = try? ObjectId(string: folderId),
               let folder = realm.object(ofType: PlaceFolderObject.self, forPrimaryKey: objectId) {
                
                if let currentFolder = realmObject.folder.first, currentFolder.id != folder.id {
                    if let index = currentFolder.places.index(of: realmObject) {
                        currentFolder.places.remove(at: index)
                    }
                    folder.places.append(realmObject)
                } else if realmObject.folder.first == nil {
                    folder.places.append(realmObject)
                }
            }
        }
    }

    func delete(id: String) {
        guard let objectId = try? ObjectId(string: id),
              let place = realm.object(ofType: MyPlaceObject.self, forPrimaryKey: objectId) else {
            return
        }
        
        if let imagePath = place.imageFileURL {
            removeImageFromDocumentsDirectory(path: imagePath)
        }
        
        try? realm.write {
            realm.delete(place)
        }
    }
    
    private func removeImageFromDocumentsDirectory(path: String) {
        let fileManager = FileManager.default
        
        let fileURL: URL
        if path.hasPrefix("/") {
            fileURL = URL(fileURLWithPath: path)
        } else {
            fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(path)
        }
        
        do {
            let absolutePath = fileURL.path
            if fileManager.fileExists(atPath: absolutePath) {
                try fileManager.removeItem(at: fileURL)
                print("이미지 삭제 성공: \(absolutePath)")
            } else {
                print("삭제할 이미지가 존재하지 않습니다: \(absolutePath)")
            }
        } catch {
            print("이미지 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    func fetchById(_ id: String) -> MyPlaceObject? {
        guard let objectId = try? ObjectId(string: id) else { return nil }
        return realm.object(ofType: MyPlaceObject.self, forPrimaryKey: objectId)
    }
}
