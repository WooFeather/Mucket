//
//  TabBarController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        delegate = self
        configureTabBarController()
        setupTabBarAppearance()
    }
    
    private func configureTabBarController() {
        let trendingVC = TrendingViewController(reactor: TrendingReactor())
        let cookingVC = CookingViewController(reactor: CookingReactor(myCookingRepository: MyCookingRepository()))
        let placeholderVC = UIViewController()
        let restaurantMapVC = RestaurantMapViewController()
        let bookmarkVC = BookmarkViewController(reactor: BookmarkReactor(repository: BookmarkedRecipeRepository()))
        
        trendingVC.tabBarItem.image = .forkKnife
        cookingVC.tabBarItem.image = .bookClosed
        placeholderVC.tabBarItem.image = .plusCircle
        restaurantMapVC.tabBarItem.image = .map
        bookmarkVC.tabBarItem.image = .bookmark
        
        let trendingNav = UINavigationController(rootViewController: trendingVC)
        let cookingNav = UINavigationController(rootViewController: cookingVC)
        let placeholderNav = UINavigationController(rootViewController: placeholderVC)
        let restaurantMapNav = UINavigationController(rootViewController: restaurantMapVC)
        let bookmarkNav = UINavigationController(rootViewController: bookmarkVC)
        
        // TODO: 2차릴리즈에서 수정
        // setViewControllers([trendingNav, cookingNav, placeholderNav, restaurantMapNav, bookmarkNav], animated: true)
        setViewControllers([trendingNav, cookingNav, bookmarkNav], animated: true)
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .backgroundPrimary
        tabBar.standardAppearance = appearance
        tabBar.tintColor = .themePrimary
        tabBar.scrollEdgeAppearance = appearance
    }
}

//extension TabBarController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if let viewControllers = self.viewControllers,
//           let index = viewControllers.firstIndex(of: viewController),
//           index == 2 {
//            presentAddRecipeModal()
//            return false
//        }
//        return true
//    }
//
//    private func presentAddRecipeModal() {
//        let addRecipeVC = AddContentsViewController()
//        addRecipeVC.modalPresentationStyle = .fullScreen
//        present(addRecipeVC, animated: true)
//    }
//}
