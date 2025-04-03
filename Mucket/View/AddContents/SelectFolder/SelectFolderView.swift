//
//  SelectFolderView.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import UIKit
import SnapKit

final class SelectFolderView: BaseView {
    private let navigationStackView = UIStackView()
    let doneButton = UIButton()
    let naviTitleLabel = UILabel()
    let addFolderButton = UIButton()
    
    let folderTableView = UITableView()
    
    override func configureHierarchy() {
        [navigationStackView, folderTableView].forEach {
            addSubview($0)
        }
        
        [addFolderButton, naviTitleLabel, doneButton].forEach {
            navigationStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        navigationStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        folderTableView.snp.makeConstraints { make in
            make.top.equalTo(navigationStackView.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        navigationStackView.axis = .horizontal
        navigationStackView.alignment = .center
        navigationStackView.distribution = .equalSpacing
        
        naviTitleLabel.text = "폴더선택"
        naviTitleLabel.font = .Head.head4
        naviTitleLabel.textColor = .textPrimary
        
        addFolderButton.setTitle("추가", for: .normal)
        addFolderButton.setTitleColor(.textPrimary, for: .normal)
        
        doneButton.setTitle("완료", for: .normal)
        doneButton.setTitleColor(.textPrimary, for: .normal)
        
        folderTableView.backgroundColor = .lightGray
    }
}
