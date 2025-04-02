//
//  SearchView.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import SnapKit

final class SearchView: BaseView {
    let roundedBackgroundView = RoundedBackgroundView()
    let backButton = UIButton()
    let searchBar = UnderlineTextField()
    let searchTableView = UITableView()
    let emptyStateView = EmptyStateView(message: "검색 결과가 없습니다. 검색어를 다시 확인해주세요.")
    let loadingIndicator = UIActivityIndicatorView()
    
    override func configureHierarchy() {
        addSubview(roundedBackgroundView)
        [backButton, searchBar, searchTableView, emptyStateView, loadingIndicator].forEach {
            roundedBackgroundView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        roundedBackgroundView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(24)
        }

        searchBar.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }

        searchTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }

        emptyStateView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
            $0.width.height.equalTo(200)
        }
    }

    override func configureView() {
        backButton.setImage(.chevronLeft, for: .normal)
        backButton.tintColor = .textPrimary
        backButton.contentMode = .scaleAspectFill
        
        searchBar.textField.returnKeyType = .search
        searchBar.textField.placeholder = "재료를 검색해 보세요."
        
        searchTableView.backgroundColor = .backgroundPrimary
        searchTableView.isHidden = true
        
        loadingIndicator.style = .medium
        loadingIndicator.color = .backgroundGray
    }
}
