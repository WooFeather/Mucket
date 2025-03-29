//
//  SearchView.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import SnapKit

final class SearchView: BaseView {
    private let roundedBackgroundView = RoundedBackgroundView()
    let backButton = UIButton()
    let searchBar = UnderlineTextField()
    let searchTableView = UITableView()
    let emptyResultImageView = UIImageView()
    let emptyResultLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(roundedBackgroundView)
        [backButton, searchBar, searchTableView, emptyResultImageView, emptyResultLabel].forEach {
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

        emptyResultImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
            $0.width.height.equalTo(80)
        }

        emptyResultLabel.snp.makeConstraints {
            $0.top.equalTo(emptyResultImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(180)
        }
    }

    override func configureView() {
        backButton.setImage(.chevronLeft, for: .normal)
        backButton.tintColor = .textPrimary
        backButton.contentMode = .scaleAspectFill
        
        searchBar.textField.returnKeyType = .search
        
        searchTableView.backgroundColor = .backgroundPrimary
        searchTableView.isHidden = true
        
        emptyResultImageView.image = .placeholder
        emptyResultImageView.contentMode = .scaleAspectFit
        
        emptyResultLabel.text = "검색 결과가 없습니다. 검색어를 다시 확인해주세요."
        emptyResultLabel.font = .Body.body2
        emptyResultLabel.textColor = .textSecondary
        emptyResultLabel.textAlignment = .center
        emptyResultLabel.numberOfLines = 2
        
        // TODO: 검색결과가 없을때 false
        [emptyResultImageView, emptyResultLabel].forEach {
            $0.isHidden = true
        }
    }
}
