//
//  SceneDelegate.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import WidgetKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let initialViewController = TabBarController()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
        NetworkMonitor.shared.startMonitoring()
        
        // 앱이 완전히 꺼진 상태에서 위젯으로 실행될때도 딥링크를 처리
        if let urlContext = connectionOptions.urlContexts.first {
            handleDeepLink(urlContext.url)
        }
        
        MemoryCache.shared.cache.totalCostLimit = 50 * 1024 * 1024
        MemoryCache.shared.cache.countLimit = 100
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleDeepLink(url)
    }
    
    // 공통 딥링크 핸들러
    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "mucket", url.host == "search" else { return }
        // url에서 쿼리 꺼내기
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let query = components?
          .queryItems?
          .first(where: { $0.name == "query" })?
          .value?
          .removingPercentEncoding ?? ""
        
        // 첫 번째 탭(TrendingVC)으로 전환
        guard
          let tabBar = window?.rootViewController as? UITabBarController,
          let nav = tabBar.viewControllers?.first as? UINavigationController
        else { return }
        tabBar.selectedIndex = 0
        
        // 스택 리셋 (중복 push 방지)
        nav.popToRootViewController(animated: false)
        
        // Reactor 생성 & 쿼리를 통해 바로 검색 액션 보내기
        let reactor = SearchReactor()
        reactor.action.onNext(.searchButtonTapped(query: query))
        
        // VC 생성 & push
        let vc = SearchViewController(reactor: reactor)
        vc.searchView.searchBar.textField.text = query
        vc.hidesBottomBarWhenPushed = true
        nav.pushViewController(vc, animated: true)
        
        // 위젯 리로드
        WidgetCenter.shared.reloadTimelines(ofKind: "RandomFoodWidget")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

