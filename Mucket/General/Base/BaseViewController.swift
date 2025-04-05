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
        enableSwipeBackGesture()
    }
    
    func configureView() {
        view.backgroundColor = .themePrimary
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configureData() { }
    
    func configureAction() { }
}

// 뒤로가기 제스처
extension BaseViewController: UIGestureRecognizerDelegate {
    private func enableSwipeBackGesture() {
        if let navigationController = navigationController,
           navigationController.viewControllers.count > 1 {
            navigationController.interactivePopGestureRecognizer?.delegate = self
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
