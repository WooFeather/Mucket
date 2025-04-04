//
//  AddCookingViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class AddCookingViewController: BaseViewController {
    private let addCookingView = AddCookingView()
    var disposeBag = DisposeBag()
    let imagePicker = UIImagePickerController()
    private var didAppear = false
    
    init(reactor: AddCookingReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableKeyboardHandling(for: addCookingView.scrollView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableKeyboardHandling()
    }
    
    override func loadView() {
        view = addCookingView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureData() {
        imagePicker.delegate = self
    }
}

// MARK: - Reactor
extension AddCookingViewController: View {
    func bind(reactor: AddCookingReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: AddCookingReactor) {
        addCookingView.addPhotoButton.rx.tap
            .map { AddCookingReactor.Action.addPhotoButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addCookingView.folderSelectButton.rx.tap
            .map { AddCookingReactor.Action.folderSelectButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func bindState(_ reactor: AddCookingReactor) {
        reactor.state
            .map { $0.isPresent }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.present(owner.imagePicker, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, route in
                switch route {
                case .folder:
                    let vc = SelectFolderViewController(reactor: SelectFolderReactor(repository: FolderRepository()))
                    vc.onFolderSelected = { selected in
                        owner.reactor?.action.onNext(.setSelectedFolder(selected))
                    }
                    owner.present(vc, animated: true)
                    owner.reactor?.action.onNext(.clearRouting)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.selectedFolder?.name ?? "기본 폴더" }
            .distinctUntilChanged()
            .bind(to: addCookingView.folderSelectButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
}

// MARK: - ImagePicker
extension AddCookingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        let image = info[UIImagePickerController.InfoKey.originalImage]
        
        if let result = image as? UIImage {
            addCookingView.previewPhotoView.image = result
        } else {
            addCookingView.previewPhotoView.image = .xmarkOctagon
        }
        
        dismiss(animated: true)
    }
}
