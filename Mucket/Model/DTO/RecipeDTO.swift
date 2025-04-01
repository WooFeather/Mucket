//
//  RecipeDTO.swift
//  Mucket
//
//  Created by 조우현 on 4/1/25.
//

import Foundation

struct RecipeDTO: Decodable {
    let recipeInfo: RecipeInfoDTO
    
    enum CodingKeys: String, CodingKey {
        case recipeInfo = "COOKRCP01"
    }
}

struct RecipeInfoDTO: Decodable {
    let totalCount: String
    let row: [RecipeDetailDTO]
    let result: ResultDTO
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case row
        case result = "RESULT"
    }
}

struct ResultDTO: Decodable {
    let msg: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case msg = "MSG"
        case code = "CODE"
    }
}

struct RecipeDetailDTO: Decodable {
    let rcpPartsDtls: String?
    let rcpWay2: String?
    let manualImg20: String?
    let manual20: String?
    let rcpSeq: String?
    let infoNa: String?
    let infoWgt: String?
    let infoPro: String?
    let manualImg13: String?
    let manualImg14: String?
    let manualImg15: String?
    let manualImg16: String?
    let manualImg10: String?
    let manualImg11: String?
    let manualImg12: String?
    let manualImg17: String?
    let manualImg18: String?
    let manualImg19: String?
    let infoFat: String?
    let hashTag: String?
    let manualImg02: String?
    let manualImg03: String?
    let rcpPat2: String?
    let manualImg04: String?
    let manualImg05: String?
    let manualImg01: String?
    let manual01: String?
    let attFileNoMk: String?
    let manualImg06: String?
    let manualImg07: String?
    let manualImg08: String?
    let manualImg09: String?
    let manual08: String?
    let manual09: String?
    let manual06: String?
    let manual07: String?
    let manual04: String?
    let manual05: String?
    let manual02: String?
    let manual03: String?
    let attFileNoMain: String?
    let manual11: String?
    let manual12: String?
    let manual10: String?
    let infoCar: String?
    let manual19: String?
    let rcpNaTip: String?
    let infoEng: String?
    let manual17: String?
    let manual18: String?
    let rcpNm: String?
    let manual15: String?
    let manual16: String?
    let manual13: String?
    let manual14: String?

    enum CodingKeys: String, CodingKey {
        case rcpPartsDtls = "RCP_PARTS_DTLS"
        case rcpWay2 = "RCP_WAY2"
        case manualImg20 = "MANUAL_IMG20"
        case manual20 = "MANUAL20"
        case rcpSeq = "RCP_SEQ"
        case infoNa = "INFO_NA"
        case infoWgt = "INFO_WGT"
        case infoPro = "INFO_PRO"
        case manualImg13 = "MANUAL_IMG13"
        case manualImg14 = "MANUAL_IMG14"
        case manualImg15 = "MANUAL_IMG15"
        case manualImg16 = "MANUAL_IMG16"
        case manualImg10 = "MANUAL_IMG10"
        case manualImg11 = "MANUAL_IMG11"
        case manualImg12 = "MANUAL_IMG12"
        case manualImg17 = "MANUAL_IMG17"
        case manualImg18 = "MANUAL_IMG18"
        case manualImg19 = "MANUAL_IMG19"
        case infoFat = "INFO_FAT"
        case hashTag = "HASH_TAG"
        case manualImg02 = "MANUAL_IMG02"
        case manualImg03 = "MANUAL_IMG03"
        case rcpPat2 = "RCP_PAT2"
        case manualImg04 = "MANUAL_IMG04"
        case manualImg05 = "MANUAL_IMG05"
        case manualImg01 = "MANUAL_IMG01"
        case manual01 = "MANUAL01"
        case attFileNoMk = "ATT_FILE_NO_MK"
        case manualImg06 = "MANUAL_IMG06"
        case manualImg07 = "MANUAL_IMG07"
        case manualImg08 = "MANUAL_IMG08"
        case manualImg09 = "MANUAL_IMG09"
        case manual08 = "MANUAL08"
        case manual09 = "MANUAL09"
        case manual06 = "MANUAL06"
        case manual07 = "MANUAL07"
        case manual04 = "MANUAL04"
        case manual05 = "MANUAL05"
        case manual02 = "MANUAL02"
        case manual03 = "MANUAL03"
        case attFileNoMain = "ATT_FILE_NO_MAIN"
        case manual11 = "MANUAL11"
        case manual12 = "MANUAL12"
        case manual10 = "MANUAL10"
        case infoCar = "INFO_CAR"
        case manual19 = "MANUAL19"
        case rcpNaTip = "RCP_NA_TIP"
        case infoEng = "INFO_ENG"
        case manual17 = "MANUAL17"
        case manual18 = "MANUAL18"
        case rcpNm = "RCP_NM"
        case manual15 = "MANUAL15"
        case manual16 = "MANUAL16"
        case manual13 = "MANUAL13"
        case manual14 = "MANUAL14"
    }
}
