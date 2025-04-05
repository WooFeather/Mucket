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
    let addCookingView = AddCookingView()
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
            .filter { $0 != .none }
            .subscribe(onNext: { [weak self] route in
                guard let self = self else { return }
                
                switch route {
                case .folder:
                    // 폴더 선택 화면으로 이동
                    let folderRepo = CookingFolderRepository()
                    let reactor = SelectFolderReactor(repository: folderRepo, selectedCookingId: nil)
                    let folderVC = SelectFolderViewController(reactor: reactor)
                    
                    // 폴더 선택 콜백 설정
                    folderVC.onFolderSelected = { [weak self] selectedFolder in
                        guard let self = self else { return }
                        self.reactor?.action.onNext(.setSelectedFolder(selectedFolder))
                    }
                    
                    self.present(folderVC, animated: true) {
                        // 라우팅 상태 초기화
                        self.reactor?.action.onNext(.clearRouting)
                    }
                    
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedFolder }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self) { owner, folder in
                owner.addCookingView.folderSelectButton.setTitle(folder.name, for: .normal)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.nameContents }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: addCookingView.nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.imageURLContents }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self) { owner, imageURL in
                let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageURL)
                let savedImage = UIImage(contentsOfFile: filePath.path)
                
                
                owner.addCookingView.previewPhotoView.image = savedImage ?? .placeholderSmall
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.ratingContents }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: addCookingView.ratingView.rx.rating)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.memoContents }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: addCookingView.memoTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.youtubeLinkContents }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: addCookingView.linkTextField.rx.text)
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
