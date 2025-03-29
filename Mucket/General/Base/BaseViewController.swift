//
//  BaseViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureData()
        configureAction()
        bind()
    }
    
    func configureView() {
        view.backgroundColor = .themePrimary
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configureData() { }
    
    func configureAction() { }
    
    func bind() { }
}
