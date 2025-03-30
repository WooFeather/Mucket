//
//  CookingCollectionViewCell.swift
//  Mucket
//
//  Created by 조우현 on 3/30/25.
//

import UIKit
import SnapKit

final class CookingCollectionViewCell: BaseCollectionViewCell, ReusableIdentifier {
    private let thumbImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ratingView = UIView() // TODO: CosmosView로 교체 예정
    
    override func configureHierarchy() {
        [thumbImageView, nameLabel, ratingView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        thumbImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(120)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(thumbImageView)
            make.height.equalTo(18)
        }
        
        ratingView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.height.equalTo(16)
            make.horizontalEdges.equalTo(nameLabel)
        }
    }
    
    override func configureView() {
        thumbImageView.backgroundColor = .backgroundSecondary
        thumbImageView.layer.cornerRadius = 6
        thumbImageView.image = .placeholderSmall
        thumbImageView.contentMode = .scaleAspectFit
        thumbImageView.clipsToBounds = true
        
        nameLabel.text = "닭가슴살 스테이크"
        nameLabel.font = .Body.body2
        nameLabel.textColor = .textSecondary
        
        ratingView.backgroundColor = .lightGray
    }
}
