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

    
    private let repository = CookingFolderRepository()
    private lazy var contextMenuItems = repository.fetchAll().map { $0.name }
    var didSelectFolder: ((String?) -> Void)?
    
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
            make.width.lessThanOrEqualTo(150)
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
        emptyStateView.isHidden = true
        
        configureContextMenu()
    }
    
    private func configureContextMenu() {
        // 폴더 목록에 '전체보기' 추가
        var menuItems = ["전체보기"]
        menuItems.append(contentsOf: repository.fetchAll().map { $0.name })
        
        // 드롭다운 메뉴 설정
        let actions = menuItems.enumerated().map { index, title in
            UIAction(title: title) { [weak self] _ in
                guard let self = self else { return }
                
                if index == 0 {
                    // '전체보기' 선택
                    self.filterButton.button.setTitle("전체보기", for: .normal)
                    self.didSelectFolder?(nil) // nil은 전체보기를 의미
                } else {
                    // 특정 폴더 선택
                    let folders = self.repository.fetchAll()
                    let selectedFolder = folders[index - 1] // -1은 '전체보기' 때문에
                    self.filterButton.button.setTitle(selectedFolder.name, for: .normal)
                    self.didSelectFolder?(selectedFolder.id)
                }
            }
        }
        
        filterButton.button.menu = UIMenu(title: "폴더 선택", children: actions)
        filterButton.button.showsMenuAsPrimaryAction = true
    }
    
    func updateFolderMenu() {
        configureContextMenu()
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
