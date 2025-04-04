//
//  FolderObject.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

final class MyCookingFolderObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var createdAt: Date = Date()
    @Persisted var myCookingObject: List<MyCookingObject>
}

// MARK: - Mapper
struct MyCookingFolderEntity: Equatable {
    let id: String
    let name: String
    let createdAt: Date
    let myCooking: [MyCookingEntity]
}

extension MyCookingFolderEntity {
    func toRealmObject() -> MyCookingFolderObject {
        let object = MyCookingFolderObject()
        object.id = try! ObjectId(string: id)
        object.name = name
        object.createdAt = createdAt
        object.myCookingObject.append(objectsIn: self.myCooking.map { $0.toRealmObject() })
        return object
    }
}

extension MyCookingFolderObject {
    func toEntity() -> MyCookingFolderEntity {
        return MyCookingFolderEntity(
            id: self.id.stringValue,
            name: self.name,
            createdAt: self.createdAt,
            myCooking: self.myCookingObject.map { $0.toEntity() }
        )
    }
}
