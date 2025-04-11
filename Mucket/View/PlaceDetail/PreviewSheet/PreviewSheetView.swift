//
//  PreviewSheetView.swift
//  Mucket
//
//  Created by 조우현 on 4/11/25.
//

import UIKit
import SnapKit
import Cosmos

final class PreviewSheetView: BaseView {
    private let nameLabel = UILabel()
    private let addressLabel = UILabel()
    private let ratingView = CosmosView()
    private let thumbImageView = UIImageView()
    let copyButton = UIButton()
    let detailButton = UIButton()
    
    override func configureHierarchy() {
        [nameLabel, addressLabel, ratingView, thumbImageView, copyButton, detailButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(30)
            $0.leading.equalToSuperview().offset(16)
        }

        addressLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.width.lessThanOrEqualTo(200)
            $0.leading.equalTo(nameLabel)
        }

        copyButton.snp.makeConstraints {
            $0.centerY.equalTo(addressLabel)
            $0.leading.equalTo(addressLabel.snp.trailing).offset(4)
            $0.width.height.equalTo(14)
        }

        ratingView.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
            $0.height.equalTo(20)
        }
        
        thumbImageView.snp.makeConstraints {
            $0.top.equalTo(ratingView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(thumbImageView.snp.width).multipliedBy(0.75).priority(.medium)
            $0.height.lessThanOrEqualTo(200)
            $0.bottom.lessThanOrEqualTo(detailButton.snp.top).offset(-20)
        }

        detailButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        addressLabel.setContentHuggingPriority(.required, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        addressLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    override func configureView() {
        nameLabel.font = .Head.head4
        nameLabel.textColor = .textPrimary
        
        addressLabel.font = .Body.body4
        addressLabel.textColor = .textSecondary
        
        copyButton.setImage(.squareOnSquare, for: .normal)
        copyButton.tintColor = .textSecondary
        
        ratingView.settings.updateOnTouch = false
        ratingView.settings.fillMode = .half
        
        thumbImageView.backgroundColor = .themeSecondary
        thumbImageView.layer.cornerRadius = 6
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.clipsToBounds = true
        
        detailButton.setTitle("자세히 보기", for: .normal)
        detailButton.setTitleColor(.textPrimary, for: .normal)
        detailButton.backgroundColor = .themePrimary
        detailButton.layer.cornerRadius = 12
        

    }
    
    func configureDate(entity: MyPlaceEntity) {
        nameLabel.text = entity.name
        addressLabel.text = entity.address
        ratingView.rating = entity.rating ?? 0.0
        
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
    }
}
