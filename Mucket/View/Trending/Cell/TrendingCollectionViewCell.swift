//
//  TrendingCollectionViewCell.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import SnapKit

final class TrendingCollectionViewCell: BaseCollectionViewCell, ReusableIdentifier {
    private let thumbImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override func configureHierarchy() {
        [thumbImageView, nameLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        thumbImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(160)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbImageView.snp.bottom).offset(8)
            make.leading.equalTo(thumbImageView.snp.leading)
            make.height.equalTo(15)
        }
    }
    
    override func configureView() {
        thumbImageView.backgroundColor = .backgroundSecondary
        thumbImageView.layer.cornerRadius = 6
        thumbImageView.image = .placeholderSmall
        thumbImageView.contentMode = .scaleAspectFit
        thumbImageView.clipsToBounds = true
        
        nameLabel.text = "닭가슴살 스테이크"
        nameLabel.font = .Body.body5
        nameLabel.textColor = .textSecondary
    }
    
    // TODO: 실제 모델 적용
    func configureRecommendData() {
        
    }
    
    func configureThemeData() {
        
    }
}
