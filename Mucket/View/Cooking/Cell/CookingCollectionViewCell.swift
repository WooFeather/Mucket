//
//  CookingCollectionViewCell.swift
//  Mucket
//
//  Created by 조우현 on 3/30/25.
//

import UIKit
import SnapKit
import Cosmos

final class CookingCollectionViewCell: BaseCollectionViewCell, ReusableIdentifier {
    private let thumbImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ratingView = CosmosView()
    
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
        thumbImageView.backgroundColor = .themeSecondary
        thumbImageView.layer.cornerRadius = 6
        thumbImageView.image = .placeholderSmall
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.clipsToBounds = true
        
        nameLabel.text = "닭가슴살 스테이크"
        nameLabel.font = .Body.body2
        nameLabel.textColor = .textSecondary
        
        ratingView.settings.updateOnTouch = false
    }
    
    func configureData(entity: MyCookingEntity) {
        if let fileName = entity.imageFileURL {
            // 파일명으로부터 전체 경로 생성
            let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
            let savedImage = UIImage(contentsOfFile: filePath.path)
            
            if savedImage == nil {
                print("이미지를 로드할 수 없습니다: \(filePath)")
            }
            thumbImageView.image = savedImage ?? .placeholderSmall
        } else {
            thumbImageView.image = .placeholderSmall
        }
        
        nameLabel.text = entity.name
        ratingView.rating = entity.rating ?? 0
    }
}
