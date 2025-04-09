//
//  SearchAddressView.swift
//  Mucket
//
//  Created by 조우현 on 4/9/25.
//

import UIKit
import SnapKit

final class SearchAddressView: BaseView {
    private let navigationStackView = UIStackView()
    let closeButton = UIButton()
    let naviTitleLabel = UILabel()
    let doneButton = UIButton()
    
    let searchBar = UnderlineTextField()
    let emptyStateView = EmptyStateView(message: "검색 결과가 없습니다. 주소를 다시 확인해주세요.", isHidden: false)
    let addressTableView = UITableView()
    
    override func configureHierarchy() {
        [navigationStackView, searchBar, emptyStateView, addressTableView].forEach {
            addSubview($0)
        }
        
        [closeButton, naviTitleLabel, doneButton].forEach {
            navigationStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        navigationStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(naviTitleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }
        
        addressTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        navigationStackView.axis = .horizontal
        navigationStackView.alignment = .center
        navigationStackView.distribution = .equalSpacing
        
        naviTitleLabel.text = "주소 검색"
        naviTitleLabel.font = .Head.head4
        naviTitleLabel.textColor = .textPrimary
        
        closeButton.setImage(.xmark, for: .normal)
        closeButton.setTitleColor(.textPrimary, for: .normal)
        closeButton.tintColor = .textPrimary
        
        addressTableView.backgroundColor = .lightGray
    }
}
