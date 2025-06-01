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
        let arrowImage = UIImage.arrowtriangleDownFill?.resizedAndTemplated(to: CGSize(width: 10, height: 10))
        
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .textSecondary
        config.image = arrowImage
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        button.configuration = config
        
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.font = .Body.body2
    }
    
    func setTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }
    
    func getButton() -> UIButton {
        return button
    }
}
