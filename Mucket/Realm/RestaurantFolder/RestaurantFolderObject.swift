//
//  RestaurantFolderObject.swift
//  Mucket
//
//  Created by 조우현 on 4/5/25.
//

import Foundation
import RealmSwift

class RestaurantFolderObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var createdAt: Date = Date()
    
    @Persisted var restaurants: List<RestaurantObject>
}

// MARK: - Mapper
struct RestaurantFolderEntity: Equatable {
    let id: String
    let name: String
    let createdAt: Date
}

extension RestaurantFolderEntity {
    func toRealmObject() -> RestaurantFolderObject {
        let object = RestaurantFolderObject()
        object.id = try! ObjectId(string: id)
        object.name = name
        object.createdAt = createdAt
        return object
    }
}

extension RestaurantFolderObject {
    func toEntity() -> RestaurantFolderEntity {
        return RestaurantFolderEntity(
            id: self.id.stringValue,
            name: self.name,
            createdAt: self.createdAt
        )
    }
}
