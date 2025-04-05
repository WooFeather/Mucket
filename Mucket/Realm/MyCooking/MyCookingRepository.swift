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
    func fetchAll() -> [MyCookingEntity]
    func fetch(in folderId: String?) -> [MyCookingEntity]
    func add(_ entity: MyCookingEntity, toFolderId folderId: String?)
    func update(_ entity: MyCookingEntity)
    func delete(id: String)
}

final class MyCookingRepository: MyCookingRepositoryType {
    private let realm = try! Realm()
    private let folderRepository = FolderRepository()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
    }

    func fetchAll() -> [MyCookingEntity] {
        return realm.objects(MyCookingObject.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .map { $0.toEntity() }
    }

    // 폴더별 요리 조회 메서드
    func fetch(in folderId: String?) -> [MyCookingEntity] {
        if let folderId = folderId,
           let objectId = try? ObjectId(string: folderId),
           let folder = realm.object(ofType: FolderObject.self, forPrimaryKey: objectId) {
            // 특정 폴더의 요리들 반환
            return folder.cookings.map { $0.toEntity() }
        } else {
            // 모든 요리 반환
            return fetchAll()
        }
    }
    
    // 요리 추가 메서드 - Entity를 받아서 처리
    func add(_ entity: MyCookingEntity, toFolderId folderId: String? = nil) {
        let realmObject = entity.toRealmObject()
        
        try? realm.write {
            realm.add(realmObject)
            
            // 폴더에 요리 추가
            let folderObjectId: ObjectId?
            if let folderId = folderId {
                folderObjectId = try? ObjectId(string: folderId)
            } else {
                // 기본 폴더 사용
                let defaultFolder = folderRepository.getDefaultFolder()
                folderObjectId = try? ObjectId(string: defaultFolder.id)
            }
            
            if let folderObjectId = folderObjectId,
               let folder = realm.object(ofType: FolderObject.self, forPrimaryKey: folderObjectId) {
                folder.cookings.append(realmObject)
            }
        }
    }
    
    func update(_ entity: MyCookingEntity) {
        let realmObject = entity.toRealmObject()
        
        try? realm.write {
            realm.add(realmObject, update: .modified)
            
            // 폴더 관계 업데이트가 필요한 경우
            if let folderId = entity.folderId,
               let objectId = try? ObjectId(string: folderId),
               let folder = realm.object(ofType: FolderObject.self, forPrimaryKey: objectId) {
                
                // 이전 폴더에서 제거하고 새 폴더에 추가
                if let currentFolder = realmObject.folder.first, currentFolder.id != folder.id {
                    if let index = currentFolder.cookings.index(of: realmObject) {
                        currentFolder.cookings.remove(at: index)
                    }
                    folder.cookings.append(realmObject)
                } else if realmObject.folder.first == nil {
                    // 폴더가 없는 경우 새 폴더에 추가
                    folder.cookings.append(realmObject)
                }
            }
        }
    }
    
    func delete(id: String) {
        guard let objectId = try? ObjectId(string: id),
              let cooking = realm.object(ofType: MyCookingObject.self, forPrimaryKey: objectId) else {
            return
        }
        
        try? realm.write {
            realm.delete(cooking)
        }
    }
}
