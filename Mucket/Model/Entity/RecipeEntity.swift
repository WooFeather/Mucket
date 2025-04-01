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
    let type: String?
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
            type: rcpPat2,
            carbs: infoCar,
            protein: infoPro,
            fat: infoFat,
            sodium: infoNa,
            manualSteps: steps
        )
    }
}

extension RecipeEntity {
    static var mockList: [RecipeEntity] {
        return [
            RecipeEntity(
                id: "1",
                name: "간단 카레 레시피",
                imageURL: "https://www.foodsafetykorea.go.kr/uploadimg/cook/10_00037_2.png",
                ingredients: "감자, 당근, 양파, 카레가루, 소고기",
                type: "국&찌개",
                carbs: "30.5",
                protein: "15.4",
                fat: "17.7",
                sodium: "57.8",
                manualSteps: [
                    .init(order: 1, description: "감자를 깍둑썰기하고 팬에 볶는다.", imageURL: nil),
                    .init(order: 2, description: "카레가루를 넣고 물과 함께 끓인다.", imageURL: nil),
                    .init(order: 3, description: "다 익으면 그릇에 담아 완성한다.", imageURL: nil)
                ]
            ),
            RecipeEntity(
                id: "2",
                name: "된장국",
                imageURL: nil,
                ingredients: "두부, 감자, 애호박, 된장, 대파",
                type: "국&찌개",
                carbs: "7.3",
                protein: "5.4",
                fat: "3.1",
                sodium: "320",
                manualSteps: [
                    .init(order: 1, description: "냄비에 물과 된장을 푼다.", imageURL: nil),
                    .init(order: 2, description: "재료들을 썰어 넣고 끓인다.", imageURL: nil),
                    .init(order: 3, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 4, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 5, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 6, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 7, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 8, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 9, description: "냄비에 물과 된장을 푼다.", imageURL: nil),
                    .init(order: 10, description: "재료들을 썰어 넣고 끓인다.", imageURL: nil),
                    .init(order: 11, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 12, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 13, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 14, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 15, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 16, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 17, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 18, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 19, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 20, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil)
                ]
            ),
            RecipeEntity(
                id: "2",
                name: "된장국",
                imageURL: nil,
                ingredients: "두부, 감자, 애호박, 된장, 대파",
                type: "반찬",
                carbs: "7.3",
                protein: "5.4",
                fat: "3.1",
                sodium: "320",
                manualSteps: [
                    .init(order: 1, description: "냄비에 물과 된장을 푼다.", imageURL: nil),
                    .init(order: 2, description: "재료들을 썰어 넣고 끓인다.", imageURL: nil),
                    .init(order: 3, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 4, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 5, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 6, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 7, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 8, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 9, description: "냄비에 물과 된장을 푼다.", imageURL: nil),
                    .init(order: 10, description: "재료들을 썰어 넣고 끓인다.", imageURL: nil),
                    .init(order: 11, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 12, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 13, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 14, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 15, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 16, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 17, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 18, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 19, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 20, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil)
                ]
            ),
            RecipeEntity(
                id: "2",
                name: "된장국",
                imageURL: nil,
                ingredients: "두부, 감자, 애호박, 된장, 대파",
                type: "일품",
                carbs: "7.3",
                protein: "5.4",
                fat: "3.1",
                sodium: "320",
                manualSteps: [
                    .init(order: 1, description: "냄비에 물과 된장을 푼다.", imageURL: nil),
                    .init(order: 2, description: "재료들을 썰어 넣고 끓인다.", imageURL: nil),
                    .init(order: 3, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 4, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 5, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 6, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 7, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 8, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 9, description: "냄비에 물과 된장을 푼다.", imageURL: nil),
                    .init(order: 10, description: "재료들을 썰어 넣고 끓인다.", imageURL: nil),
                    .init(order: 11, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 12, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 13, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 14, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 15, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 16, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 17, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 18, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 19, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 20, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil)
                ]
            ),
            RecipeEntity(
                id: "2",
                name: "된장국",
                imageURL: nil,
                ingredients: "두부, 감자, 애호박, 된장, 대파",
                type: "기타",
                carbs: "7.3",
                protein: "5.4",
                fat: "3.1",
                sodium: "320",
                manualSteps: [
                    .init(order: 1, description: "냄비에 물과 된장을 푼다.", imageURL: nil),
                    .init(order: 2, description: "재료들을 썰어 넣고 끓인다.", imageURL: nil),
                    .init(order: 3, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 4, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 5, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 6, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 7, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 8, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 9, description: "냄비에 물과 된장을 푼다.", imageURL: nil),
                    .init(order: 10, description: "재료들을 썰어 넣고 끓인다.", imageURL: nil),
                    .init(order: 11, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 12, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 13, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 14, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 15, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 16, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 17, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 18, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 19, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil),
                    .init(order: 20, description: "대파를 마지막에 넣고 마무리한다.", imageURL: nil)
                ]
            )
        ]
    }
}
