//
//  BookmarkViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class BookmarkViewController: BaseViewController {
    private let bookmarkView = BookmarkView()
    var disposeBag = DisposeBag()
    
    init(reactor: BookmarkReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let reactor = self.reactor else { return }
        
        Observable.just(())
            .map { BookmarkReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = bookmarkView
    }
    
    override func configureData() {
        bookmarkView.bookmarkTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
    }
}

// MARK: - Reactor
extension BookmarkViewController: View {
    func bind(reactor: BookmarkReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: BookmarkReactor) {
        bookmarkView.bookmarkTableView.rx.modelSelected(RecipeEntity.self)
            .map { BookmarkReactor.Action.recipeCellTapped($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bookmarkView.searchBar.textField.rx.text.orEmpty
            .map { BookmarkReactor.Action.searchButtonTapped(query: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: BookmarkReactor) {
        reactor.state
            .map { $0.bookmarkRecipes }
            .distinctUntilChanged()
            .bind(to: bookmarkView.bookmarkTableView.rx.items(cellIdentifier: SearchTableViewCell.id, cellType: SearchTableViewCell.self)) { row, entity, cell in
                cell.configureData(entity: entity)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.bookmarkRecipes.isEmpty }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEmpty in
                owner.bookmarkView.emptyStateView.isHidden = !isEmpty
                owner.bookmarkView.bookmarkTableView.isHidden = isEmpty
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .distinctUntilChanged { $0 == $1 }
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, route in
                switch route {
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
            .map { $0.isKeyboardHidden }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, isHidden in
                if isHidden {
                    owner.bookmarkView.searchBar.textField.resignFirstResponder()
                }
            }
            .disposed(by: disposeBag)
    }
}
