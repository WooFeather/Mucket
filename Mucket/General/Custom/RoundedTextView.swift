//
//  RoundedTextField.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import SnapKit

final class RoundedTextView: BaseView {
    private let roundedBackground = UIView()
    private let magnifyingGlassImageView = UIImageView()
    private let placeholderLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
    }
    
    override func configureHierarchy() {
        addSubview(roundedBackground)
        roundedBackground.addSubview(magnifyingGlassImageView)
        roundedBackground.addSubview(placeholderLabel)
    }
    
    override func configureLayout() {
        roundedBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        magnifyingGlassImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(20)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        self.backgroundColor = .backgroundPrimary
        
        roundedBackground.layer.cornerRadius = 22
        
        magnifyingGlassImageView.image = .magnifyingglass
        magnifyingGlassImageView.contentMode = .scaleAspectFill
        magnifyingGlassImageView.tintColor = .textPrimary
        
        placeholderLabel.text = "어떤 요리를 만들어볼까요?"
        placeholderLabel.font = .Body.body2
        placeholderLabel.textColor = .textSecondary
        placeholderLabel.textAlignment = .center
    }
}
