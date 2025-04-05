//
//  CookingModificationView.swift
//  Mucket
//
//  Created by 조우현 on 4/5/25.
//

import UIKit
import SnapKit

final class CookingModificationView: BaseView {
    private let navigationStackView = UIStackView()
    let cancelButton = UIButton()
    let saveButton = UIButton()
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    override func configureHierarchy() {
        [navigationStackView, pageViewController.view].forEach {
            addSubview($0)
        }
        
        [cancelButton, saveButton].forEach {
            navigationStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        navigationStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(navigationStackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.textPrimary, for: .normal)

        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(.textPrimary, for: .normal)

        navigationStackView.axis = .horizontal
        navigationStackView.distribution = .equalSpacing
        navigationStackView.alignment = .center
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
}
