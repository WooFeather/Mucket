//
//  SelectFolderViewController.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class SelectFolderViewController: BaseViewController {
    private let selectFolderView = SelectFolderView()
    var disposeBag = DisposeBag()
    
    init(reactor: SelectFolderReactor) {
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
            .map{ SelectFolderReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = selectFolderView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureData() {
        selectFolderView.folderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "folderTableViewCell")
    }
}

extension SelectFolderViewController: View {
    func bind(reactor: SelectFolderReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: SelectFolderReactor) {
        
    }
    
    private func bindState(_ reactor: SelectFolderReactor) {
        reactor.state
            .map { $0.folderList }
            .distinctUntilChanged()
            .bind(to: selectFolderView.folderTableView.rx.items(cellIdentifier: "folderTableViewCell", cellType: UITableViewCell.self)) { row, entity, cell in
                cell.backgroundColor = .clear
                
                cell.textLabel?.text = entity.name
                
                // TODO: 선택된 폴더인지에 따라 분기처리
                cell.accessoryType = .checkmark
                cell.tintColor = .themePrimary
            }
            .disposed(by: disposeBag)
    }
}
