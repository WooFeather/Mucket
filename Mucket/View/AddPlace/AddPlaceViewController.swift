//
//  AddRestaurantViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class AddPlaceViewController: BaseViewController {
    let addPlaceView = AddPlaceView()
    var disposeBag = DisposeBag()
    let imagePicker = UIImagePickerController()
    
    init(reactor: AddPlaceReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableKeyboardHandling(for: addPlaceView.scrollView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableKeyboardHandling()
    }
    
    override func loadView() {
        view = addPlaceView
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
extension AddPlaceViewController: View {
    func bind(reactor: AddPlaceReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: AddPlaceReactor) {
        addPlaceView.addPhotoButton.rx.tap
            .map { AddPlaceReactor.Action.addPhotoButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addPlaceView.folderSelectButton.rx.tap
            .map {AddPlaceReactor.Action.folderPlaceButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addPlaceView.addressButton.rx.tap
            .map {
                AddPlaceReactor.Action.searchAddressButtonTapped
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: AddPlaceReactor) {
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
            .filter { $0 != .none }
            .bind(with: self) {
                owner,
                route in
                switch route {
                case .searchAddress:
                    let searchVC = SearchAddressViewController(reactor: SearchAddressReactor())
                    searchVC.onAddressSelected = { [weak self] place in
                        self?.reactor?.action.onNext(
                            .setAddressInfo(
                                address: place.roadAddressName,
                                latitude: Double(place.y),
                                longitude: Double(place.x)
                            )
                        )
                    }
                    
                    owner.present(searchVC, animated: true) {
                        owner.reactor?.action.onNext(.clearRouting)
                    }
                case .folder:
                    let folderRepo = PlaceFolderRepository()
                    let reactor = PlaceFolderReactor(repository: folderRepo, selectedPlaceId: nil)
                    let folderVC = PlaceFolderViewController(reactor: reactor)
                    folderVC.onFolderSelected = { [weak self] selectedFolder in
                        self?.reactor?.action.onNext(.setSelectedFolder(selectedFolder))
                    }
                    
                    self.present(folderVC, animated: true) {
                        self.reactor?.action.onNext(.clearRouting)
                    }
                    
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedFolder }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self) { owner, folder in
                owner.addPlaceView.folderSelectButton.setTitle(folder.name, for: .normal)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.nameContents }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: addPlaceView.nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.imageURLContents }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self) { owner, imageURL in
                let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageURL)
                let savedImage = UIImage(contentsOfFile: filePath.path)
                
                
                owner.addPlaceView.previewPhotoView.image = savedImage ?? .placeholderSmall
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.ratingContents }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: addPlaceView.ratingView.rx.rating)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.memoContents }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: addPlaceView.memoTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.addressContents }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self) { owner, address in
                owner.addPlaceView.addressButton.setTitle(address, for: .normal)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - ImagePicker
extension AddPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        let image = info[UIImagePickerController.InfoKey.originalImage]
        
        if let result = image as? UIImage {
            addPlaceView.previewPhotoView.image = result
        } else {
            addPlaceView.previewPhotoView.image = .xmarkOctagon
        }
        
        dismiss(animated: true)
    }
}
