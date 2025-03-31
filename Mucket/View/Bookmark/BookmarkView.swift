//
//  BookmarkView.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import UIKit
import SnapKit

final class BookmarkView: BaseView {
    private let roundedBackgroundView = RoundedBackgroundView()
    private let naviTitleLabel = UILabel()
    let searchBar = UnderlineTextField()
    let bookmarkTableView = UITableView()
    let emptyStateView = EmptyStateView(message: "북마크한 레시피가 없습니다. 좋아하는 레시피를 찾아보세요.", isHidden: false)
    
    override func configureHierarchy() {
        addSubview(roundedBackgroundView)
        [naviTitleLabel, searchBar, bookmarkTableView, emptyStateView].forEach {
            roundedBackgroundView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        roundedBackgroundView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        naviTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.height.equalTo(26)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(naviTitleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }
        
        bookmarkTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        emptyStateView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
            $0.width.height.equalTo(200)
        }
    }
    
    override func configureView() {
        naviTitleLabel.text = "북마크"
        naviTitleLabel.textColor = .textPrimary
        naviTitleLabel.font = .Head.head2
        
        searchBar.textField.returnKeyType = .search
        searchBar.textField.placeholder = "레시피를 검색해 보세요."
        
        bookmarkTableView.backgroundColor = .backgroundPrimary
        bookmarkTableView.isHidden = false
        
        // TODO: 검색결과가 없을때 emptyStateView isHidden = false
        emptyStateView.isHidden = true
    }
}
