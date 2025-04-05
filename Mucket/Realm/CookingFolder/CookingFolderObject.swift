//
//  FolderObject.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

final class CookingFolderObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var createdAt: Date = Date()
    
    @Persisted var cookings: List<MyCookingObject>
}

// MARK: - Mapper
struct CookingFolderEntity: Equatable {
    let id: String
    let name: String
    let createdAt: Date
}

extension CookingFolderEntity {
    func toRealmObject() -> CookingFolderObject {
        let object = CookingFolderObject()
        object.id = try! ObjectId(string: id)
        object.name = name
        object.createdAt = createdAt
        return object
    }
}

extension CookingFolderObject {
    func toEntity() -> CookingFolderEntity {
        return CookingFolderEntity(
            id: self.id.stringValue,
            name: self.name,
            createdAt: self.createdAt
        )
    }
}
