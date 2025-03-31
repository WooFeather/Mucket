//
//  UnderlineTextField.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import SnapKit

final class UnderlineTextField: BaseView {
    private let underlineView = UIView()
    private let magnifyingGlassImageView = UIImageView()
    let textField = UITextField()

    override func configureHierarchy() {
        [underlineView, textField, magnifyingGlassImageView].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        textField.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.trailing.equalTo(magnifyingGlassImageView.snp.trailing).offset(-12)
            make.height.equalTo(40)
        }
        
        magnifyingGlassImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(20)
        }
        
        underlineView.snp.makeConstraints { make in
            make.leading.equalTo(textField.snp.leading)
            make.trailing.equalTo(magnifyingGlassImageView.snp.trailing)
            make.height.equalTo(1)
            make.top.equalTo(textField.snp.bottom)
        }
    }
    
    override func configureView() {
        textField.tintColor = .textPrimary
        textField.textColor = .textPrimary
        
        magnifyingGlassImageView.image = .magnifyingglass
        magnifyingGlassImageView.contentMode = .scaleAspectFill
        magnifyingGlassImageView.tintColor = .textSecondary
        
        underlineView.backgroundColor = .textPrimary
    }
}
