//
//  Cashable.swift
//  Moving
//
//  Created by 조우현 on 3/25/25.
//

import Foundation

protocol Cacheable {
    /// URL로부터 고유한 Key를 추출하는 함수
    func createKey(from url: URL) -> String
}

extension Cacheable {
    func createKey(from url: URL) -> String {
        let stringURL = url.absoluteString
        let stringArray = stringURL.split(separator: ".")
        return String(stringArray[stringArray.count - 2])
    }
}
