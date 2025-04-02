//
//  ViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import ReactorKit
import RxCocoa
import RxGesture

final class TrendingViewController: BaseViewController {
    
    private let trendingView = TrendingView()
    var disposeBag = DisposeBag()
    
    init(reactor: TrendingReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = trendingView
    }
    
    override func configureData() {
        trendingView.recommendCollectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCollectionViewCell.id)
        trendingView.themeCollectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCollectionViewCell.id)
    }
}

// MARK: - Reactor
extension TrendingViewController: View {
    func bind(reactor: TrendingReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: TrendingReactor) {
        let type = trendingView.themeButton.button.title(for: .normal) ?? "밥"
        reactor.action.onNext(.reloadTrigger(type: type))
        
        trendingView.searchView.rx.tapGesture()
            .when(.recognized)
            .map { _ in
                TrendingReactor.Action.searchViewTapped
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: TrendingReactor) {
        reactor.state
            .map { $0.shouldRouteToSearchView }
            .distinctUntilChanged()
            .filter { $0 == .searchView }
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                let vc = SearchViewController(reactor: SearchReactor())
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
                owner.reactor?.action.onNext(.clearRouting) // 다시 push가 되지 않게 clear
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.recommendedList }
            .distinctUntilChanged()
            .bind(to: trendingView.recommendCollectionView.rx.items(
                cellIdentifier: TrendingCollectionViewCell.id,
                cellType: TrendingCollectionViewCell.self
            )) { _, entity, cell in
                cell.configureData(entity: entity)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.themeList }
            .distinctUntilChanged()
            .bind(to: trendingView.themeCollectionView.rx.items(
                cellIdentifier: TrendingCollectionViewCell.id,
                cellType: TrendingCollectionViewCell.self
            )) { _, entity, cell in
                cell.configureData(entity: entity)
            }
            .disposed(by: disposeBag)
    }
}
