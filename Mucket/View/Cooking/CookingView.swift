//
//  CookingView.swift
//  Mucket
//
//  Created by 조우현 on 3/30/25.
//

import UIKit
import SnapKit

final class CookingView: BaseView {
    private let roundedBackgroundView = RoundedBackgroundView()
    private let myCookingHeader = UILabel()
    let filterButton = DropdownButton(title: "전체보기")
    let emptyStateView = EmptyStateView(message: "레시피 기록이 없습니다. +버튼을 눌러 추가해보세요.", isHidden: false)
    
    lazy var myCookingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    override func configureHierarchy() {
        addSubview(roundedBackgroundView)
        
        [myCookingHeader, filterButton, myCookingCollectionView, emptyStateView].forEach {
            roundedBackgroundView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        roundedBackgroundView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        myCookingHeader.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.height.equalTo(26)
        }
        
        filterButton.snp.makeConstraints { make in
            make.centerY.equalTo(myCookingHeader)
            make.leading.equalTo(myCookingHeader.snp.trailing).offset(8)
        }
        
        myCookingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(myCookingHeader.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        emptyStateView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
            $0.width.height.equalTo(200)
        }
    }
    
    override func configureView() {
        myCookingHeader.text = "나의 요리"
        myCookingHeader.textColor = .textPrimary
        myCookingHeader.font = .Head.head2
        
        myCookingCollectionView.backgroundColor = .backgroundPrimary
//         myCookingCollectionView.isHidden = true
        
        // TODO: 데이터가 있을때 emptyStateView isHidden = true
         emptyStateView.isHidden = true
    }
}

extension CookingView {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            return section
        }
        
        return layout
    }
}
