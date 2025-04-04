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
    var onFolderSelected: ((FolderEntity) -> Void)?

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
            .map { SelectFolderReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let reactor = self.reactor else { return }
        
        let folder = reactor.currentState.selectedFolder
        onFolderSelected?(folder)
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

// MARK: - Reactor
extension SelectFolderViewController: View {
    func bind(reactor: SelectFolderReactor) {
        selectFolderView.folderTableView.rx.modelSelected(FolderEntity.self)
            .bind(with: self) { owner, folder in
                reactor.action.onNext(.setSelectedFolder(folderId: folder.id))
            }
            .disposed(by: disposeBag)

        selectFolderView.doneButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.folderList }
            .distinctUntilChanged()
            .bind(to: selectFolderView.folderTableView.rx.items(cellIdentifier: "folderTableViewCell", cellType: UITableViewCell.self)) { _, entity, cell in
                cell.backgroundColor = .clear
                cell.textLabel?.text = entity.name
                cell.accessoryType = (entity.id == reactor.currentState.selectedFolder.id) ? .checkmark : .none
                cell.tintColor = .themePrimary
            }
            .disposed(by: disposeBag)
    }
}
