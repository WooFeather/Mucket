//
//  DropdownButton.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import UIKit
import SnapKit

final class DropdownButton: BaseView {
    
    let button = UIButton(type: .system)
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title)
    }
    
    override func configureHierarchy() {
        addSubview(button)
    }
    
    override func configureLayout() {
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        button.setTitleColor(.textSecondary, for: .normal)
        button.setImage(.arrowtriangleDownFill?.resizedAndTemplated(to: CGSize(width: 10, height: 10)), for: .normal)
        button.tintColor = .textSecondary
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .leading
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -4)
        button.titleEdgeInsets = .zero
        button.titleLabel?.font = .Body.body2
    }
    
    func setTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }
    
    func getButton() -> UIButton {
        return button
    }
}
