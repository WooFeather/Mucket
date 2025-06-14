//
//  SearchViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import ReactorKit
import RxCocoa
import RxGesture

final class SearchViewController: BaseViewController {
    
    let searchView = SearchView()
    var disposeBag = DisposeBag()
    
    init(reactor: SearchReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchView.searchBar.textField.becomeFirstResponder()
    }
    
    override func loadView() {
        view = searchView
    }
    
    override func configureData() {
        searchView.searchTableView.register(
            SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        searchView.searchTableView.prefetchDataSource = self
    }
    
    override func configureView() {
        super.configureView()
        searchView.searchTableView.keyboardDismissMode = .onDrag
    }
}

// MARK: - Reactor
extension SearchViewController: View {
    func bind(reactor: SearchReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: SearchReactor) {
        searchView.backButton.rx.tap
            .map { SearchReactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchView.searchBar.textField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(searchView.searchBar.textField.rx.text.orEmpty)
            .map { SearchReactor.Action.searchButtonTapped(query: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchView.searchTableView.rx.modelSelected(RecipeEntity.self)
            .map { SearchReactor.Action.searchCellTapped(recipe: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ rector: SearchReactor) {
        reactor?.state
            .map { $0.shouldPopToPrevView }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor?.state
            .map { $0.isSearchTableViewHidden }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isHidden in
                owner.searchView.searchTableView.isHidden = isHidden
                if !isHidden {
                    owner.searchView.searchBar.textField.resignFirstResponder()
                }
            }
            .disposed(by: disposeBag)
        
        rector.state
            .map { $0.isEmptyStateHidden }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isHidden in
                owner.searchView.emptyStateView.isHidden = isHidden
                if !isHidden {
                    owner.searchView.searchTableView.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        reactor?.state
            .map { $0.searchResult }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: searchView.searchTableView.rx.items(
                cellIdentifier: SearchTableViewCell.id,
                cellType: SearchTableViewCell.self
            )) { row, entity, cell in
                cell.configureData(entity: entity)
            }
            .disposed(by: disposeBag)
        
        reactor?.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isLoading in
                if isLoading {
                    owner.searchView.loadingIndicator.startAnimating()
                } else {
                    owner.searchView.loadingIndicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
        
        rector.state
            .map { $0.route }
            .distinctUntilChanged { $0 == $1 }
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, route in
                switch route {
                case .detail(recipe: let recipe):
                    let vc = RecipeDetailViewController(reactor: RecipeDetailReactor(recipe: recipe, repository: BookmarkedRecipeRepository()))
                    owner.navigationController?.pushViewController(vc, animated: true)
                    owner.reactor?.action.onNext(.clearRouting)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        reactor?.state
            .map { $0.alertMessage }
            .distinctUntilChanged()
            .compactMap { $0 } // nil 제거
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, message in
                owner.showAlert(title: "검색실패!", message: message, button: "확인") {
                    owner.dismiss(animated: true)
                }
                owner.reactor?.action.onNext(.clearAlert)
            }
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let reactor = reactor else { return }
        let maxIndex = indexPaths.map { $0.row }.max() ?? 0
        reactor.action.onNext(.loadNextPageIfNeeded(index: maxIndex))
    }
}
