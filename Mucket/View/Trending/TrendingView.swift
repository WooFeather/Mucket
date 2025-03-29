//
//  TrendingView.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import SnapKit

final class TrendingView: BaseView {
    private let logoImageView = UIImageView()
    private let titleImageView = UIImageView()
    private let searchView = RoundedTextView()
    private let roundedBackgroundView = UIView()
    private let recommendFoodHeader = UILabel()
    private let themeFoodHeader = UILabel()
    private let themeButton = UIButton()
    
    lazy var recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    lazy var themeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func configureHierarchy() {
        [logoImageView, titleImageView, searchView, roundedBackgroundView].forEach {
            addSubview($0)
        }
        
        [recommendFoodHeader, themeFoodHeader, themeButton, recommendCollectionView, themeCollectionView].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(60)
        }

        titleImageView.snp.makeConstraints {
            $0.centerY.equalTo(logoImageView)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(8)
            $0.height.equalTo(40)
            $0.width.equalTo(100)
        }

        searchView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }

        roundedBackgroundView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(28)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        recommendFoodHeader.snp.makeConstraints {
            $0.top.equalTo(roundedBackgroundView.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        recommendCollectionView.snp.makeConstraints {
            $0.top.equalTo(recommendFoodHeader.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }

        themeFoodHeader.snp.makeConstraints {
            $0.top.equalTo(recommendCollectionView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }

        themeButton.snp.makeConstraints {
            $0.centerY.equalTo(themeFoodHeader)
            $0.leading.equalTo(themeFoodHeader.snp.trailing).offset(8)
        }

        themeCollectionView.snp.makeConstraints {
            $0.top.equalTo(themeFoodHeader.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
    
    override func configureView() {
        logoImageView.backgroundColor = .lightGray
        DispatchQueue.main.async { [weak self] in
            self?.logoImageView.layer.cornerRadius = (self?.logoImageView.frame.width ?? 0) / 2
        }
        
        titleImageView.backgroundColor = .lightGray
        
        searchView.layer.cornerRadius = 30
        
        recommendFoodHeader.text = "오늘의 추천 요리"
        themeFoodHeader.text = "테마요리"
        
        [recommendFoodHeader, themeFoodHeader].forEach {
            $0.textColor = .textPrimary
            $0.font = .Head.head2
        }

        themeButton.setTitle("국&찌개", for: .normal)
        themeButton.setTitleColor(.textSecondary, for: .normal)
        themeButton.setImage(.arrowtriangleDownFill, for: .normal)
        themeButton.tintColor = .textSecondary
        themeButton.semanticContentAttribute = .forceRightToLeft
        themeButton.contentHorizontalAlignment = .leading
        themeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -4)
        themeButton.titleEdgeInsets = .zero
        themeButton.titleLabel?.font = .Body.body2
        
        roundedBackgroundView.backgroundColor = .backgroundPrimary
        roundedBackgroundView.layer.cornerRadius = 20
        roundedBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        roundedBackgroundView.layer.masksToBounds = true
        
        recommendCollectionView.backgroundColor = .lightGray
        
        themeCollectionView.backgroundColor = .lightGray
    }
}

extension TrendingView {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
        
        return layout
    }
}
