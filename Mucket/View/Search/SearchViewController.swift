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
    
    private let searchView = SearchView()
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
        searchView.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        searchView.searchTableView.delegate = self
        searchView.searchTableView.dataSource = self
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
            .map { SearchReactor.Action.searchButtonTapped }
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
        
        rector.state
            .map { $0.isSearchTableViewHidden }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, isHidden in
                owner.searchView.searchTableView.isHidden = isHidden
                
                if !isHidden {
                    owner.searchView.searchBar.textField.resignFirstResponder()
                }
            }
            .disposed(by: disposeBag)
    }
}

// TODO: Rx로 구현
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
