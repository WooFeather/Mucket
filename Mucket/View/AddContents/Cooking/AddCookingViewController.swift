//
//  AddCookingViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import UIKit

final class AddCookingViewController: BaseViewController {
    private let addCookingView = AddCookingView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableKeyboardHandling(for: addCookingView.scrollView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableKeyboardHandling()
    }
    
    override func loadView() {
        view = addCookingView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
}
