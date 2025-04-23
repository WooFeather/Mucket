//
//  SearchTableViewCell.swift
//  Mucket
//
//  Created by 조우현 on 3/30/25.
//

import UIKit
import SnapKit

final class SearchTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private var imageLoadTask: Task<Void, Never>?
    private let thumbImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ingredientLabel = UILabel()
    private let chevronImageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        imageLoadTask = nil
        thumbImageView.image = .placeholderSmall
    }
    
    override func configureHierarchy() {
        [thumbImageView, nameLabel, ingredientLabel, chevronImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        thumbImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.height.equalTo(78)
            make.width.equalTo(110)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(thumbImageView.snp.trailing).offset(12)
            make.height.equalTo(20)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-12)
        }
        
        ingredientLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(nameLabel.snp.horizontalEdges)
            make.bottom.equalToSuperview().offset(-36)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
    }
    
    override func configureView() {
        thumbImageView.backgroundColor = .themeSecondary
        thumbImageView.image = .placeholderSmall
        thumbImageView.layer.cornerRadius = 6
        thumbImageView.clipsToBounds = true
        thumbImageView.contentMode = .scaleAspectFill
        
        nameLabel.text = "간편 카레 레시피"
        nameLabel.font = .Body.body1
        nameLabel.textColor = .textPrimary
        
        ingredientLabel.text = "감자, 카레가루, 당근, 양파, 브로콜리, 밥"
        ingredientLabel.font = .Body.body4
        ingredientLabel.textColor = .textSecondary
        ingredientLabel.numberOfLines = 2
        
        chevronImageView.image = .chevronRight
        chevronImageView.tintColor = .textPrimary
        chevronImageView.contentMode = .scaleAspectFill
    }
    
    func configureData(entity: RecipeEntity) {
        imageLoadTask?.cancel()

        nameLabel.text = entity.name
        ingredientLabel.text = entity.ingredients

        guard let urlString = entity.imageURL,
              let url = URL(string: urlString.toHTTPS())
        else {
            thumbImageView.image = .placeholderSmall
            return
        }

        let thumbSize = thumbImageView.bounds.size == .zero ? CGSize(width: 110, height: 78) : thumbImageView.bounds.size

        imageLoadTask = Task { [weak self] in
            do {
                let img = try await ImageCacheManager
                    .shared
                    .load(
                      url: url,
                      saveOption: .onlyMemory,
                      thumbSize: thumbSize
                    )
                
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self?.thumbImageView.image = img ?? .placeholderSmall
                }
            } catch {
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self?.thumbImageView.image = .placeholderSmall
                }
            }
        }
    }
}
