//
//  UIImage +.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit

extension UIImage {
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
