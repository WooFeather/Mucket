//
//  ViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import SnapKit

class TrendingViewController: UIViewController {
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요우오우오우오"
        label.font = .Body.body5
        label.textAlignment = .center
        return label
    }()
    
    private let testImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = .forkKnife
        return imgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        
        view.addSubview(testLabel)
        view.addSubview(testImageView)
        
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        testImageView.snp.makeConstraints { make in
            make.top.equalTo(testLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(30)
        }
    }
}
