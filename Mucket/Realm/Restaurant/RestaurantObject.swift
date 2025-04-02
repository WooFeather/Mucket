//
//  RestaurantObject.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

class PlaceObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
    @Persisted var imageFileURL: String?
    @Persisted var memo: String?
    @Persisted var rating: Double?
    @Persisted var createdAt: Date = Date()

    @Persisted var folder: FolderObject?
}

// MARK: - Mapper
struct PlaceEntity: Equatable {
    let id: String
    let name: String
    let latitude: Double?
    let longitude: Double?
    let imageFileURL: String?
    let memo: String?
    let rating: Double?
    let createdAt: Date
    let folderId: String?
}

extension PlaceEntity {
    func toRealmObject(folder: FolderObject?) -> PlaceObject {
        let object = PlaceObject()
        object.id = try! ObjectId(string: id)
        object.name = name
        object.latitude = latitude
        object.longitude = longitude
        object.imageFileURL = imageFileURL
        object.memo = memo
        object.rating = rating
        object.createdAt = createdAt
        object.folder = folder
        return object
    }
}

extension PlaceObject {
    func toEntity() -> PlaceEntity {
        return PlaceEntity(
            id: self.id.stringValue,
            name: self.name,
            latitude: self.latitude,
            longitude: self.longitude,
            imageFileURL: self.imageFileURL,
            memo: self.memo,
            rating: self.rating,
            createdAt: self.createdAt,
            folderId: self.folder?.id.stringValue
        )
    }
}
