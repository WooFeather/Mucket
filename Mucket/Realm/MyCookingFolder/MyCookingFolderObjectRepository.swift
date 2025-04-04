//
//  FolderRepository.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

protocol MyCookingFolderRepositoryType {
    func getFileURL()
    func fetchAll() -> [MyCookingFolderEntity]
    func add(name: String) -> MyCookingFolderEntity
    func delete(id: String)
//    func getDefaultFolder() -> MyCookingFolderEntity
//    func setSelectedFolder(_ folderId: String)
//    func getSelectedFolder() -> MyCookingFolderEntity?
}

final class MyCookingFolderRepository: MyCookingFolderRepositoryType {
    private let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
    }

    func fetchAll() -> [MyCookingFolderEntity] {
        return realm.objects(MyCookingFolderObject.self)
            .sorted(byKeyPath: "createdAt")
            .map { $0.toEntity() }
    }

    func add(name: String) -> MyCookingFolderEntity {
        let folder = MyCookingFolderObject()
        
        do {
            try realm.write {
                realm.add(folder)
            }
        } catch {
            print("폴더 저장 실패")
        }
        
        return folder.toEntity()
    }

    func delete(id: String) {
        guard let objectId = try? ObjectId(string: id),
              let folder = realm.object(ofType: MyCookingFolderObject.self, forPrimaryKey: objectId) else { return }

        do {
            try realm.write {
                realm.delete(folder.myCookingObject)
                realm.delete(folder)
            }
        } catch {
            print("폴더 삭제 실패")
        }
    }

//    func getDefaultFolder() -> MyCookingFolderEntity {
//        // 기본 폴더가 없으면 생성하고, 있으면 반환
//        if let defaultFolder = realm.objects(MyCookingFolderObject.self).filter("name == %@", "기본 폴더").first {
//            return defaultFolder.toEntity() // 기본 폴더 반환
//        } else {
//            // 기본 폴더가 없으면 생성해서 저장
//            let defaultFolder = MyCookingFolderObject()
//            defaultFolder.name = "기본 폴더"
//            try? realm.write {
//                realm.add(defaultFolder)
//            }
//            return defaultFolder.toEntity() // 새로 생성된 기본 폴더 반환
//        }
//    }
//    
//    func setSelectedFolder(_ folderId: String) {
//        let folders = realm.objects(MyCookingFolderObject.self)
//        try? realm.write {
//            folders.setValue(false, forKey: "isSelected")
//            if let selectedFolder = folders.first(where: { $0.id.stringValue == folderId }) {
//                selectedFolder.isSelected = true
//            }
//        }
//    }
//
//    func getSelectedFolder() -> MyCookingFolderEntity? {
//        if let selectedFolder = realm.objects(MyCookingFolderObject.self).filter("isSelected == true").first {
//            return selectedFolder.toEntity()
//        } else {
//            return nil
//        }
//    }
}
