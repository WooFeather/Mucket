//
//  BookmarkViewCOntroller.swift
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
    
    override func loadView() {
        view = bookmarkView
    }
    
    override func configureData() {
        bookmarkView.bookmarkTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        bookmarkView.bookmarkTableView.delegate = self
        bookmarkView.bookmarkTableView.dataSource = self
    }
}

// MARK: - Reactor
extension BookmarkViewController: View {
    func bind(reactor: BookmarkReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: BookmarkReactor) {
        bookmarkView.searchBar.textField.rx.controlEvent(.editingDidEndOnExit)
            .map { BookmarkReactor.Action.searchButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ rector: BookmarkReactor) {
        rector.state
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

// TODO: Rx로 구현
extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
