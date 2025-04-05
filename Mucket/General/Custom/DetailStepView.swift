//
//  DetailStepView.swift
//  Mucket
//
//  Created by 조우현 on 4/6/25.
//

import UIKit
import SnapKit

final class DetailStepView: BaseView {
    private let thumbImageView = UIImageView()
    private let descriptionContainer = UIView()
    private let descriptionLabel = UILabel()
    
    override func configureHierarchy() {
        [thumbImageView, descriptionContainer].forEach {
            addSubview($0)
        }
        descriptionContainer.addSubview(descriptionLabel)
    }
    
    override func configureLayout() {
        thumbImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        
        descriptionContainer.snp.makeConstraints { make in
            make.top.equalTo(thumbImageView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    override func configureView() {
        thumbImageView.backgroundColor = .themeSecondary
        thumbImageView.image = .placeholderSmall
        thumbImageView.layer.cornerRadius = 6
        thumbImageView.clipsToBounds = true
        thumbImageView.contentMode = .scaleAspectFill
        
        descriptionContainer.backgroundColor = .backgroundPrimary
        descriptionContainer.layer.borderColor = UIColor.themePrimary.cgColor
        descriptionContainer.layer.borderWidth = 1
        descriptionContainer.layer.cornerRadius = 6
        descriptionContainer.clipsToBounds = true
        
        descriptionLabel.font = .Body.body4
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.textColor = .textPrimary
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        descriptionLabel.lineBreakMode = .byClipping
    }
    
    func configureData(step: RecipeManualStep) {
        if let url = step.imageURL {
            let imageURL = URL(string: url.toHTTPS())
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
        
        descriptionLabel.text = step.description
    }
}
