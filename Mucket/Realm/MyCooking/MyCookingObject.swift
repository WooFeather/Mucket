//
//  MyCookingObject.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

class MyCookingObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var youtubeLink: String?
    @Persisted var imageFileURL: String?
    @Persisted var memo: String?
    @Persisted var rating: Double?
    @Persisted var createdAt: Date = Date()

    @Persisted var folder: FolderObject? // 관계 설정
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
    let folderId: String? // 폴더 ID만 저장해서 간접 연결
}

extension MyCookingEntity {
    func toRealmObject(folder: FolderObject?) -> MyCookingObject {
        let object = MyCookingObject()
        object.id = ObjectId.generate()
        object.name = name
        object.youtubeLink = youtubeLink
        object.imageFileURL = imageFileURL
        object.memo = memo
        object.rating = rating
        object.createdAt = createdAt
        object.folder = folder
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
            folderId: self.folder?.id.stringValue
        )
    }
}
