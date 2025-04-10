//
//  PlaceEntity.swift
//  Mucket
//
//  Created by 조우현 on 4/9/25.
//

import Foundation

struct PlaceEntity: Equatable {
    let details: [PlaceDetail]
    let info: SearchInfo
}

struct PlaceDetail: Equatable {
    let id: String
    let placeName: String
    let placeURL: String
    let roadAddressName: String
    let x: String
    let y: String
}

struct SearchInfo: Equatable {
    let isEnd: Bool
}

extension PlaceDTO {
    func toEntity() -> PlaceEntity {
        return PlaceEntity(
            details: self.documents.map {
                PlaceDetail(
                    id: $0.id,
                    placeName: $0.placeName,
                    placeURL: $0.placeURL,
                    roadAddressName: $0.roadAddressName,
                    x: $0.x,
                    y: $0.y
                )
            },
            info: SearchInfo(isEnd: self.meta.isEnd))
    }
}

extension PlaceEntity {
    static var mockData: PlaceEntity {
        return PlaceEntity(
            details: [
                PlaceDetail(
                    id: "25037411",
                    placeName: "원조두꺼비집불오징어",
                    placeURL: "http://place.map.kakao.com/25037411",
                    roadAddressName: "서울 은평구 연서로28길 5",
                    x: "126.92100106119523",
                    y: "37.618100370960875"
                ),
                PlaceDetail(
                    id: "18508914",
                    placeName: "양지석쇠불고기백반",
                    placeURL: "http://place.map.kakao.com/18508914",
                    roadAddressName: "경기 용인시 처인구 양지로 116",
                    x: "127.28133163741273",
                    y: "37.23424037144186"
                ),
                PlaceDetail(
                    id: "2143580448",
                    placeName: "팔당불오징어불닭발",
                    placeURL: "http://place.map.kakao.com/2143580448",
                    roadAddressName: "경기 의정부시 망월로28번길 42",
                    x: "127.043186235008",
                    y: "37.7069097070703"
                ),
                PlaceDetail(
                    id: "333543684",
                    placeName: "문래동냉삼 본점",
                    placeURL: "http://place.map.kakao.com/333543684",
                    roadAddressName: "서울 영등포구 도림로147길 1",
                    x: "126.889387445627",
                    y: "37.5166012675922"
                ),
                PlaceDetail(
                    id: "14595758",
                    placeName: "이연국수",
                    placeURL: "http://place.map.kakao.com/14595758",
                    roadAddressName: "전북특별자치도 전주시 덕진구 견훤왕궁로 286-3",
                    x: "127.14457814284677",
                    y: "35.84356088529327"
                )
            ],
            info: SearchInfo(isEnd: false)
        )
    }
}
