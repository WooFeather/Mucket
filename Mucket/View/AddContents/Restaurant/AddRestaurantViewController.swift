//
//  AddRestaurantViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import UIKit

final class AddRestaurantViewController: BaseViewController {
    private let addRestaurantView = AddRestaurantView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableKeyboardHandling(for: addRestaurantView.scrollView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableKeyboardHandling()
    }
    
    override func loadView() {
        view = addRestaurantView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
}
