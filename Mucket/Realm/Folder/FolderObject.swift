//
//  FolderObject.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

class FolderObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var createdAt: Date = Date()
}

// MARK: - Mapper
struct FolderEntity: Equatable {
    let id: String
    let name: String
    let createdAt: Date
}

extension FolderEntity {
    func toRealmObject() -> FolderObject {
        let object = FolderObject()
        object.id = try! ObjectId(string: id)
        object.name = name
        object.createdAt = createdAt
        return object
    }
}

extension FolderObject {
    func toEntity() -> FolderEntity {
        return FolderEntity(
            id: self.id.stringValue,
            name: self.name,
            createdAt: self.createdAt
        )
    }
}
