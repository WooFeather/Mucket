//
//  AddContentsViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit

final class AddContentsViewController: BaseViewController {
    private let addContentsView = AddContentsView()
    
    private lazy var dataViewControllers: [UIViewController] = [
        AddCookingViewController(reactor: AddCookingReactor()),
        AddRestaurantViewController(reactor: AddRestaurantReactor())
    ]
    
    private var currentPage: Int = 0 {
        didSet {
            guard currentPage >= 0 && currentPage < dataViewControllers.count else { return }
            
            let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
            addContentsView.pageViewController.setViewControllers([dataViewControllers[currentPage]], direction: direction, animated: true)
            addContentsView.segmentedControl.selectedSegmentIndex = currentPage
        }
    }
    
    override func loadView() {
        view = addContentsView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureData() {
        addContentsView.pageViewController.delegate = self
        addContentsView.pageViewController.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        addContentsView.segmentedControl.selectedSegmentIndex = 0
    }
    
    override func configureAction() {
        addContentsView.segmentedControl.addTarget(self, action: #selector(changeValue), for: .valueChanged)
    }
    
    // MARK: - Actions
    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
}

// MARK: - PageViewController
extension AddContentsViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0],
              let index = self.dataViewControllers.firstIndex(of: viewController) else { return }
        
        self.currentPage = index
        addContentsView.segmentedControl.selectedSegmentIndex = index
    }
}
