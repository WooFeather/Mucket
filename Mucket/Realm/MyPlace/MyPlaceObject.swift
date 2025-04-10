//
//  RestaurantObject.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

// MARK: - Realm Object
final class MyPlaceObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
    @Persisted var imageFileURL: String?
    @Persisted var memo: String?
    @Persisted var rating: Double?
    @Persisted var createdAt: Date = Date()

    @Persisted(originProperty: "places") var folder: LinkingObjects<PlaceFolderObject>
}

// MARK: - Entity
struct MyPlaceEntity: Equatable {
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

// MARK: - Mapper
extension MyPlaceEntity {
    func toRealmObject() -> MyPlaceObject {
        let object = MyPlaceObject()
        object.id = id.isEmpty ? ObjectId.generate() : try! ObjectId(string: id)
        object.name = name
        object.latitude = latitude
        object.longitude = longitude
        object.imageFileURL = imageFileURL
        object.memo = memo
        object.rating = rating
        object.createdAt = createdAt
        return object
    }
}

extension MyPlaceObject {
    func toEntity() -> MyPlaceEntity {
        return MyPlaceEntity(
            id: self.id.stringValue,
            name: self.name,
            latitude: self.latitude,
            longitude: self.longitude,
            imageFileURL: self.imageFileURL,
            memo: self.memo,
            rating: self.rating,
            createdAt: self.createdAt,
            folderId: self.folder.first?.id.stringValue
        )
    }
}
