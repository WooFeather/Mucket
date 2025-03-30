//
//  EmptyStateView.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import UIKit
import SnapKit

final class EmptyStateView: BaseView {
    
    private let imageView = UIImageView()
    private let messageLabel = UILabel()
    
    private var messageText: String = ""
    private var initialVisibility: Bool = true
    
    init(message: String, isHidden: Bool = true) {
        self.messageText = message
        self.initialVisibility = isHidden
        super.init(frame: .zero)
    }
    
    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(messageLabel)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
            $0.width.height.equalTo(80)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.height.equalTo(40)
        }
    }
    
    override func configureView() {
        imageView.image = .placeholder
        imageView.contentMode = .scaleAspectFit
        
        messageLabel.font = .Body.body2
        messageLabel.textColor = .textSecondary
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2
        messageLabel.text = messageText
        
        isHidden = initialVisibility
    }
    
    func configure(message: String, isHidden: Bool) {
        messageLabel.text = message
        self.isHidden = isHidden
    }
}
