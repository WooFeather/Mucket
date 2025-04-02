//
//  String +.swift
//  Mucket
//
//  Created by 조우현 on 4/1/25.
//

import Foundation

extension String {
    var urlEncoded: String {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
    
    func toHTTPS() -> String {
        self.replacingOccurrences(of: "http://", with: "https://")
    }
}
