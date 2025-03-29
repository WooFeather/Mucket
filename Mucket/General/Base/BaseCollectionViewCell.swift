//
//  BaseCollectionViewCell.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
        configureCell()
    }
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
    
    func configureCell() {
        backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
