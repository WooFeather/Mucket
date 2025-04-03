//
//  AddRestaurantViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class AddRestaurantViewController: BaseViewController {
    private let addRestaurantView = AddRestaurantView()
    var disposeBag = DisposeBag()
    let imagePicker = UIImagePickerController()
    
    init(reactor: AddRestaurantReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableKeyboardHandling(for: addRestaurantView.scrollView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableKeyboardHandling()
    }
    
    override func loadView() {
        view = addRestaurantView
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
extension AddRestaurantViewController: View {
    func bind(reactor: AddRestaurantReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: AddRestaurantReactor) {
        addRestaurantView.addPhotoButton.rx.tap
            .map { AddRestaurantReactor.Action.addPhotoButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: AddRestaurantReactor) {
        reactor.state
            .map { $0.isPresent }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.present(owner.imagePicker, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - ImagePicker
extension AddRestaurantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        let image = info[UIImagePickerController.InfoKey.originalImage]
        
        if let result = image as? UIImage {
            addRestaurantView.previewPhotoView.image = result
        } else {
            addRestaurantView.previewPhotoView.image = .xmarkOctagon
        }
        
        dismiss(animated: true)
    }
}
