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
            make.horizontalEdges.equalTo(thumbImageView.snp.horizontalEdges)
            make.height.equalTo(15)
        }
    }
    
    override func configureView() {
        thumbImageView.backgroundColor = .backgroundSecondary
        thumbImageView.layer.cornerRadius = 6
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.clipsToBounds = true
        
        nameLabel.font = .Body.body2
        nameLabel.textColor = .textSecondary
    }
    
    // TODO: 실제 모델 적용
    func configureData(entity: RecipeEntity) {
        if let httpsURL = entity.imageURL?.replacingOccurrences(of: "http://", with: "https://") {
            let imageURL = URL(string: httpsURL)
            Task {
                do {
                    let image = try await ImageCacheManager.shared.load(url: imageURL, saveOption: .onlyMemory)
                    thumbImageView.image = image
                } catch {
                    print("이미지 로드 실패")
                    thumbImageView.image = .placeholderSmall
                }
            }
        } else {
            thumbImageView.image = .placeholderSmall
        }
        
        nameLabel.text = entity.name
    }
}
