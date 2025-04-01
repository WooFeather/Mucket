//
//  RecipeEntity.swift
//  Mucket
//
//  Created by 조우현 on 4/1/25.
//

import Foundation

struct RecipeEntity {
    let id: String
    let name: String
    let imageURL: String?
    let ingredients: String
    let carbs: String?
    let protein: String?
    let fat: String?
    let sodium: String?
    let manualSteps: [RecipeManualStep]
}

struct RecipeManualStep {
    let order: Int
    let description: String
    let imageURL: String?
}

extension RecipeDetailDTO {
    func toEntity() -> RecipeEntity {
        var steps: [RecipeManualStep] = []

        for i in 1...20 {
            let text: String?
            let image: String?

            switch i {
            case 1:  text = manual01; image = manualImg01
            case 2:  text = manual02; image = manualImg02
            case 3:  text = manual03; image = manualImg03
            case 4:  text = manual04; image = manualImg04
            case 5:  text = manual05; image = manualImg05
            case 6:  text = manual06; image = manualImg06
            case 7:  text = manual07; image = manualImg07
            case 8:  text = manual08; image = manualImg08
            case 9:  text = manual09; image = manualImg09
            case 10: text = manual10; image = manualImg10
            case 11: text = manual11; image = manualImg11
            case 12: text = manual12; image = manualImg12
            case 13: text = manual13; image = manualImg13
            case 14: text = manual14; image = manualImg14
            case 15: text = manual15; image = manualImg15
            case 16: text = manual16; image = manualImg16
            case 17: text = manual17; image = manualImg17
            case 18: text = manual18; image = manualImg18
            case 19: text = manual19; image = manualImg19
            case 20: text = manual20; image = manualImg20
            default: text = nil; image = nil
            }

            if let text = text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                steps.append(RecipeManualStep(order: i, description: text, imageURL: image))
            }
        }

        return RecipeEntity(
            id: rcpSeq ?? UUID().uuidString,
            name: rcpNm ?? "제목 없음",
            imageURL: attFileNoMain,
            ingredients: rcpPartsDtls ?? "",
            carbs: infoCar,
            protein: infoPro,
            fat: infoFat,
            sodium: infoNa,
            manualSteps: steps
        )
    }
}
