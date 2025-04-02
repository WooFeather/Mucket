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
    private let roundedBackgroundView = RoundedBackgroundView()
    private let recommendFoodHeader = UILabel()
    private let themeFoodHeader = UILabel()
    private let contextMenuItems = ["밥", "반찬", "국&찌개", "후식", "일품", "기타"]
    let searchView = RoundedTextView()
    lazy var themeButton = DropdownButton(title: contextMenuItems[0])
    let recommendedLoadingIndicator = UIActivityIndicatorView()
    let themeLoadingIndicator = UIActivityIndicatorView()
    
    var didSelectTheme: ((String) -> Void)?
    
    lazy var recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    lazy var themeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func configureHierarchy() {
        [logoImageView, titleImageView, searchView, roundedBackgroundView].forEach {
            addSubview($0)
        }
        
        [recommendFoodHeader, themeFoodHeader, themeButton, recommendCollectionView, themeCollectionView].forEach {
            roundedBackgroundView.addSubview($0)
        }
        
        recommendCollectionView.addSubview(recommendedLoadingIndicator)
        themeCollectionView.addSubview(themeLoadingIndicator)
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
            $0.height.equalTo(30)
            $0.width.equalTo(80)
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
            $0.top.leading.equalToSuperview().offset(16)
        }

        recommendCollectionView.snp.makeConstraints {
            $0.top.equalTo(recommendFoodHeader.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        recommendedLoadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
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
        
        themeLoadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
    }
    
    override func configureView() {
        logoImageView.image = .symbol
        logoImageView.contentMode = .scaleAspectFit
        
        titleImageView.image = .logo
        titleImageView.contentMode = .scaleAspectFit
        
        searchView.layer.cornerRadius = 30
        
        recommendFoodHeader.text = "오늘의 추천 요리"
        themeFoodHeader.text = "테마요리"
        
        [recommendFoodHeader, themeFoodHeader].forEach {
            $0.textColor = .textPrimary
            $0.font = .Head.head2
        }
        
        recommendCollectionView.backgroundColor = .backgroundPrimary
        recommendCollectionView.isScrollEnabled = false
        themeCollectionView.backgroundColor = .backgroundPrimary
        themeCollectionView.isScrollEnabled = false
        
        [recommendedLoadingIndicator, themeLoadingIndicator].forEach {
            $0.style = .medium
            $0.color = .backgroundGray
        }
        
        configureContextMenu()
    }
    
    private func configureContextMenu() {
        let actions = contextMenuItems.map { title in
            UIAction(title: title) { [weak self] _ in
                self?.themeButton.button.setTitle(title, for: .normal)
                self?.didSelectTheme?(title)
            }
        }

        themeButton.button.menu = UIMenu(title: "요리 종류 선택", children: actions)
        themeButton.button.showsMenuAsPrimaryAction = true
    }
}

extension TrendingView {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .absolute(200))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
        
        return layout
    }
}
