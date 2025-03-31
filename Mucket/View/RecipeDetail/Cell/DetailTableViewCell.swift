//
//  DetailTableViewCell.swift
//  Mucket
//
//  Created by 조우현 on 3/30/25.
//

import UIKit
import SnapKit

final class DetailTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private let thumbImageView = UIImageView()
    private lazy var descriptionView = BackgroundContentView(contentView: descriptionTextView)
    private let descriptionTextView = UITextView()
    
    override func configureHierarchy() {
        [thumbImageView, descriptionView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        thumbImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.width.equalTo(200)
            make.height.equalTo(140)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(thumbImageView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    override func configureView() {
        thumbImageView.backgroundColor = .backgroundSecondary
        thumbImageView.image = .placeholderSmall
        thumbImageView.layer.cornerRadius = 6
        thumbImageView.clipsToBounds = true
        thumbImageView.contentMode = .scaleAspectFill
        
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.font = .Body.body4
        descriptionTextView.textColor = .textPrimary
        descriptionTextView.text = "1. 닭을 깨끗이 손질하고, 부위별로 자른다."
    }
    
    // TODO: 실제 모델 적용
    func configureData() {
        
    }
}
