//
//  TrendingCollectionViewCell.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import SnapKit

final class TrendingCollectionViewCell: BaseCollectionViewCell, ReusableIdentifier {
    private var imageLoadTask: Task<Void, Never>?
    private let thumbImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        imageLoadTask = nil
        thumbImageView.image = .placeholderSmall
    }
    
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
        thumbImageView.backgroundColor = .themeSecondary
        thumbImageView.layer.cornerRadius = 6
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.clipsToBounds = true
        
        nameLabel.font = .Body.body2
        nameLabel.textColor = .textSecondary
    }
    
    func configureData(entity: RecipeEntity) {
        imageLoadTask?.cancel()
        
        nameLabel.text = entity.name
        
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
