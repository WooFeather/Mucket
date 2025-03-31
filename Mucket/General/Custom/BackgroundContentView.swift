//
//  BackgroundContentView.swift
//  Mucket
//
//  Created by 조우현 on 4/1/25.
//

import UIKit
import SnapKit

final class BackgroundContentView: BaseView {

    let backgroundView = UIView()
    let contentView: UIView

    init(contentView: UIView) {
        self.contentView = contentView
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureHierarchy() {
        addSubview(backgroundView)
        backgroundView.addSubview(contentView)
    }

    override func configureLayout() {
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints { $0.edges.equalToSuperview().inset(12) }
    }

    override func configureView() {
        backgroundView.backgroundColor = .backgroundSecondary
        backgroundView.layer.cornerRadius = 6
    }
}

