//
//  PlaceDetailViewController.swift
//  Mucket
//
//  Created by 조우현 on 4/11/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class PlaceDetailViewController: BaseViewController {
    private let placeDetailView = PlaceDetailView()
    var disposeBag = DisposeBag()
    
    init(reactor: PlaceDetailReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = placeDetailView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureData() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePlaceUpdated),
            name: NSNotification.Name("PlaceUpdated"),
            object: nil
        )
    }

    @objc private func handlePlaceUpdated() {
        guard let reactor = self.reactor else { return }
        reactor.action.onNext(.refreshData)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Reactor
extension PlaceDetailViewController: View {
    func bind(reactor: PlaceDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: PlaceDetailReactor) {
        placeDetailView.backButton.rx.tap
            .map { PlaceDetailReactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        placeDetailView.didSelectEditMenu = {
            let cooking = reactor.currentState.place
            reactor.action.onNext(.editButtonTapped(cooking))
        }
        
        placeDetailView.didSelectDeleteMenu = {
            reactor.action.onNext(.deleteButtonTapped)
        }
    }
    
    private func bindState(_ reactor: PlaceDetailReactor) {
        reactor.state
            .map { $0.route }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, route in
                switch route {
                case .prevView:
                    owner.navigationController?.popViewController(animated: true)
                    owner.reactor?.action.onNext(.clearRouting)
                case .editView(let place):
                    let vc = PlaceModificationViewController(editingPlaceId: place.id)
                    vc.modalPresentationStyle = .fullScreen
                    owner.present(vc, animated: true)
                    owner.reactor?.action.onNext(.clearRouting)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.place.name }
            .distinctUntilChanged()
            .bind(to: placeDetailView.naviTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.place.imageFileURL }
            .distinctUntilChanged()
            .bind(with: self) { owner, urlString in
                
                let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(urlString ?? "")
                let savedImage = UIImage(contentsOfFile: filePath.path)
                
                owner.placeDetailView.thumbImageView.image = savedImage ?? .placeholderSmall
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.place.memo }
            .distinctUntilChanged()
            .bind(to: placeDetailView.memoTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.place.rating }
            .distinctUntilChanged()
            .bind(with: self) { owner, rating in
                owner.placeDetailView.ratingView.rating = rating ?? 0
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.place.address }
            .distinctUntilChanged()
            .bind(with: self) { owner, address in
                owner.placeDetailView.addressLabel.text = address
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.showDeleteAlert }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "삭제하기", message: "이 맛집을 삭제하시겠습니까?", button: "삭제", style: .destructive, isCancelButton: true) {
                    owner.reactor?.action.onNext(.confirmDeleteTapped)
                }
                owner.reactor?.action.onNext(.clearShowAlert)
            }
            .disposed(by: disposeBag)
    }
}
