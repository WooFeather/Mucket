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
        reactor.action.onNext(.loadAll(type: type))
        
        trendingView.didSelectTheme = { [weak self] selectedType in
            self?.reactor?.action.onNext(.loadTheme(type: selectedType == "국&찌개" ? "국" : selectedType))
        }
        
        trendingView.searchView.rx.tapGesture()
            .when(.recognized)
            .map { _ in
                TrendingReactor.Action.searchViewTapped
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        trendingView.recommendCollectionView.rx.modelSelected(RecipeEntity.self)
            .map { TrendingReactor.Action.recipeCellTapped(recipe: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        trendingView.themeCollectionView.rx.modelSelected(RecipeEntity.self)
            .map { TrendingReactor.Action.recipeCellTapped(recipe: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: TrendingReactor) {
        reactor.state
            .map { $0.route }
            .distinctUntilChanged { $0 == $1 }
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, route in
                switch route {
                case .searchView:
                    let vc = SearchViewController(reactor: SearchReactor())
                    vc.hidesBottomBarWhenPushed = true
                    owner.navigationController?.pushViewController(vc, animated: true)
                    owner.reactor?.action.onNext(.clearRouting)

                case .detail(let recipe):
                    let vc = RecipeDetailViewController(reactor: RecipeDetailReactor(recipe: recipe, repository: BookmarkedRecipeRepository()))
                    vc.hidesBottomBarWhenPushed = true
                    owner.navigationController?.pushViewController(vc, animated: true)
                    owner.reactor?.action.onNext(.clearRouting)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.recommendedList }
            .distinctUntilChanged { $0.map(\.id) == $1.map(\.id) }
            .observe(on: MainScheduler.instance)
            .bind(to: trendingView.recommendCollectionView.rx.items(
                cellIdentifier: TrendingCollectionViewCell.id,
                cellType: TrendingCollectionViewCell.self
            )) { _, entity, cell in
                cell.configureData(entity: entity)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.themeList }
            .distinctUntilChanged { $0.map(\.id) == $1.map(\.id) }
            .observe(on: MainScheduler.instance)
            .bind(to: trendingView.themeCollectionView.rx.items(
                cellIdentifier: TrendingCollectionViewCell.id,
                cellType: TrendingCollectionViewCell.self
            )) { _, entity, cell in
                cell.configureData(entity: entity)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoadingRecommended }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isLoading in
                if isLoading {
                    owner.trendingView.recommendedLoadingIndicator.startAnimating()
                } else {
                    owner.trendingView.recommendedLoadingIndicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoadingTheme }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isLoading in
                if isLoading {
                    owner.trendingView.themeLoadingIndicator.startAnimating()
                } else {
                    owner.trendingView.themeLoadingIndicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
    }
}
