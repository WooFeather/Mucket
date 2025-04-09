//
//  UIImage+.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit

extension UIImage {
    static let forkKnife = UIImage(systemName: "fork.knife")
    static let map = UIImage(systemName: "map")
    static let plusCircle = UIImage(systemName: "plus.circle")
    static let magnifyingglass = UIImage(systemName: "magnifyingglass")
    static let bookmark = UIImage(systemName: "bookmark")
    static let bookmarkFill = UIImage(systemName: "bookmark.fill")
    static let line3Horizontal = UIImage(systemName: "line.3.horizontal")
    static let xmark = UIImage(systemName: "xmark")
    static let plus = UIImage(systemName: "plus")
    static let pencil = UIImage(systemName: "pencil")
    static let chevronRight = UIImage(systemName: "chevron.right")
    static let chevronLeft = UIImage(systemName: "chevron.left")
    static let arrowtriangleDownFill = UIImage(systemName: "arrowtriangle.down.fill")
    static let bookClosed = UIImage(systemName: "book.closed")
    static let squareOnSquare = UIImage(systemName: "square.on.square")
    static let xmarkOctagon = UIImage(systemName: "xmark.octagon")
    static let location = UIImage(systemName: "location")
    static let locationFill = UIImage(systemName: "location.fill")
    
    /// 버튼 안의 이미지 크기 조절
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
    
    func resizedAndTemplated(to size: CGSize) -> UIImage {
        return self.resize(to: size).withRenderingMode(.alwaysTemplate)
    }
}
