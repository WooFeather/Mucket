//
//  BookmarkObject.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import RealmSwift

final class BookmarkedRecipeObject: Object {
    @Persisted(primaryKey: true) var id: String // RCP_SEQ
    @Persisted var name: String
    @Persisted var imageUrl: String?
    @Persisted var ingredients: String
    @Persisted var type: String?
    @Persisted var carbs: String?
    @Persisted var protein: String?
    @Persisted var fat: String?
    @Persisted var sodium: String?
    @Persisted var manualSteps = List<ManualStepObject>()
}

final class ManualStepObject: Object {
    @Persisted var order: Int
    @Persisted var descriptionText: String
    @Persisted var imageUrl: String?
}

// MARK: - Mapper
extension RecipeEntity {
    func toRealmObject() -> BookmarkedRecipeObject {
        let object = BookmarkedRecipeObject()
        object.id = self.id
        object.name = self.name
        object.imageUrl = self.imageURL
        object.ingredients = self.ingredients
        object.type = self.type
        object.carbs = self.carbs
        object.protein = self.protein
        object.fat = self.fat
        object.sodium = self.sodium
        object.manualSteps.append(objectsIn: self.manualSteps.map { step in
            let stepObject = ManualStepObject()
            stepObject.order = step.order
            stepObject.descriptionText = step.description
            stepObject.imageUrl = step.imageURL
            return stepObject
        })
        return object
    }
}

extension BookmarkedRecipeObject {
    func toEntity() -> RecipeEntity {
        return RecipeEntity(
            id: self.id,
            name: self.name,
            imageURL: self.imageUrl,
            ingredients: self.ingredients,
            type: self.type,
            carbs: self.carbs,
            protein: self.protein,
            fat: self.fat,
            sodium: self.sodium,
            manualSteps: self.manualSteps.map {
                RecipeManualStep(order: $0.order, description: $0.descriptionText, imageURL: $0.imageUrl)
            }
        )
    }
}
