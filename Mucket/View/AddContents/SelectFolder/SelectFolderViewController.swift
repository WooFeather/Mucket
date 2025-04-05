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
    var onFolderSelected: ((CookingFolderEntity) -> Void)?

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
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        guard let reactor = self.reactor else { return }
//        
//        let folder = reactor.currentState.selectedFolder
//        onFolderSelected?(folder)
//    }

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
        selectFolderView.folderTableView.rx.modelSelected(CookingFolderEntity.self)
            .bind(with: self) { owner, folder in
                reactor.action.onNext(.setSelectedFolder(folderId: folder.id))
            }
            .disposed(by: disposeBag)
        
        selectFolderView.doneButton.rx.tap
            .bind(with: self) { owner, _ in
                if let selectedFolderId = reactor.currentState.selectedFolderId,
                   let selected = reactor.currentState.folderList.first(where: { $0.id == selectedFolderId }) {
                    owner.onFolderSelected?(selected)
                }
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.folderList }
            .distinctUntilChanged()
            .bind(to: selectFolderView.folderTableView.rx.items(
                cellIdentifier: "folderTableViewCell",
                cellType: UITableViewCell.self
            )) { [weak self] _, entity, cell in
                guard let self = self else { return }

                cell.backgroundColor = .clear
                cell.textLabel?.text = entity.name
                let selectedId = reactor.currentState.selectedFolderId
                cell.accessoryType = (entity.id == selectedId) ? .checkmark : .none
                cell.tintColor = .themePrimary
            }
            .disposed(by: disposeBag)
        
        selectFolderView.addFolderButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAddFolderAlert()
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedFolderId }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.selectFolderView.folderTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func showAddFolderAlert() {
        let alert = UIAlertController(title: "새 폴더 추가", message: "폴더 이름을 입력하세요", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "폴더 이름"
            textField.clearButtonMode = .whileEditing
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            guard let self = self,
                  let reactor = self.reactor,
                  let text = alert.textFields?.first?.text,
                  !text.isEmpty else { return }
            
            // 폴더 추가 액션 전달
            reactor.action.onNext(.addFolder(name: text))
            
            // 폴더 추가 알림 발송
            NotificationCenter.default.post(name: NSNotification.Name("FolderListUpdated"), object: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true)
    }
}
