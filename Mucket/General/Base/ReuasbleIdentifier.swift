//
//  ReuasbleIdentifier.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import Foundation

protocol ReusableIdentifier { }

extension ReusableIdentifier {
    static var id: String {
        return String(describing: self)
    }
}
