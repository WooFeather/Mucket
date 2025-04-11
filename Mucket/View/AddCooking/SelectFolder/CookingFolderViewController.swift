//
//  SelectFolderViewController.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class CookingFolderViewController: BaseViewController {
    private let selectFolderView = SelectFolderView()
    var disposeBag = DisposeBag()
    var onFolderSelected: ((CookingFolderEntity) -> Void)?

    init(reactor: CookingFolderReactor) {
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
            .map { CookingFolderReactor.Action.viewWillAppear }
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
        selectFolderView.folderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cookingFolderTableViewCell")
    }
}

// MARK: - Reactor
extension CookingFolderViewController: View {
    func bind(reactor: CookingFolderReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: CookingFolderReactor) {
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
        
        selectFolderView.addFolderButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAddFolderAlert()
            }
            .disposed(by: disposeBag)
        
        selectFolderView.folderTableView.rx.itemDeleted
            .bind(with: self) { owner, indexPath in
                guard let reactor = owner.reactor else { return }
                let folder = reactor.currentState.folderList[indexPath.row]
                // 기본 폴더는 삭제 방지
                if folder.name == "기본 폴더" {
                    owner.showAlert(title: "삭제 불가", message: "기본 폴더는 삭제할 수 없습니다.", button: "확인") { }
                } else {
                    owner.showAlert(title: "폴더 삭제", message: "해당 폴더에 속한 요리는 '기본 폴더'로 이동하게 됩니다. 폴더를 삭제하시겠습니까?", button: "삭제", style: .destructive, isCancelButton: true) {
                        reactor.action.onNext(.deleteFolder(id: folder.id))
                        NotificationCenter.default.post(name: NSNotification.Name("CookingFolderListUpdated"), object: nil)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: CookingFolderReactor) {
        reactor.state
            .map { $0.folderList }
            .distinctUntilChanged()
            .bind(to: selectFolderView.folderTableView.rx.items(
                cellIdentifier: "cookingFolderTableViewCell",
                cellType: UITableViewCell.self
            )) { [weak self] _, entity, cell in
                guard self != nil else { return }

                cell.backgroundColor = .clear
                cell.textLabel?.text = entity.name
                let selectedId = reactor.currentState.selectedFolderId
                cell.accessoryType = (entity.id == selectedId) ? .checkmark : .none
                cell.tintColor = .themePrimary
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
            NotificationCenter.default.post(name: NSNotification.Name("CookingFolderListUpdated"), object: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true)
    }
}
