//
//  MyCookingObject.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

final class MyCookingObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var youtubeLink: String?
    @Persisted var imageFileURL: String?
    @Persisted var memo: String?
    @Persisted var rating: Double?
    @Persisted var createdAt: Date = Date()

    @Persisted(originProperty: "cookings") var folder: LinkingObjects<CookingFolderObject>
}


// MARK: - Mapper
struct MyCookingEntity: Equatable {
    let id: String
    let name: String
    let youtubeLink: String?
    let imageFileURL: String?
    let memo: String?
    let rating: Double?
    let createdAt: Date
    let folderId: String? // 폴더 ID 저장

    func toRealmObject() -> MyCookingObject {
        let object = MyCookingObject()
        object.id = id.isEmpty ? ObjectId.generate() : try! ObjectId(string: id)
        object.name = name
        object.youtubeLink = youtubeLink
        object.imageFileURL = imageFileURL
        object.memo = memo
        object.rating = rating
        object.createdAt = createdAt
        return object
    }
}

extension MyCookingObject {
    func toEntity() -> MyCookingEntity {
        return MyCookingEntity(
            id: self.id.stringValue,
            name: self.name,
            youtubeLink: self.youtubeLink,
            imageFileURL: self.imageFileURL,
            memo: self.memo,
            rating: self.rating,
            createdAt: self.createdAt,
            folderId: self.folder.first?.id.stringValue
        )
    }
}
