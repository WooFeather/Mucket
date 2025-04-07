//
//  RestaurantFolderObject.swift
//  Mucket
//
//  Created by 조우현 on 4/5/25.
//

import Foundation
import RealmSwift

final class PlaceFolderObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var createdAt: Date = Date()
    
    @Persisted var places: List<PlaceObject>
}

// MARK: - Mapper
struct PlaceFolderEntity: Equatable {
    let id: String
    let name: String
    let createdAt: Date
}

extension PlaceFolderEntity {
    func toRealmObject() -> PlaceFolderObject {
        let object = PlaceFolderObject()
        object.id = try! ObjectId(string: id)
        object.name = name
        object.createdAt = createdAt
        return object
    }
}

extension PlaceFolderObject {
    func toEntity() -> PlaceFolderEntity {
        return PlaceFolderEntity(
            id: self.id.stringValue,
            name: self.name,
            createdAt: self.createdAt
        )
    }
}
