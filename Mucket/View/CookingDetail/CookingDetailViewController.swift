//
//  CookingDetailViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class CookingDetailViewController: BaseViewController {
    private let cookingView = CookingDetailView()
    var disposeBag = DisposeBag()
    
    init(reactor: CookingDetailReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = cookingView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureData() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCookingUpdated),
            name: NSNotification.Name("CookingDataUpdated"),
            object: nil
        )
    }

    @objc private func handleCookingUpdated() {
        guard let reactor = self.reactor else { return }
        reactor.action.onNext(.refreshData)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Reactor
extension CookingDetailViewController: View {
    func bind(reactor: CookingDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: CookingDetailReactor) {
        cookingView.backButton.rx.tap
            .map { CookingDetailReactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        cookingView.didSelectEditMenu = {
            let cooking = reactor.currentState.cooking
            reactor.action.onNext(.editButtonTapped(cooking))
        }
        
        cookingView.didSelectDeleteMenu = {
            reactor.action.onNext(.deleteButtonTapped)
        }
    }
    
    private func bindState(_ reactor: CookingDetailReactor) {
        reactor.state
            .map { $0.route }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, route in
                switch route {
                case .prevView:
                    owner.navigationController?.popViewController(animated: true)
                    owner.reactor?.action.onNext(.clearRouting)
                case .editView(let cooking):
                    let vc = CookingModificationViewController(editingCookingId: cooking.id)
                    owner.navigationController?.pushViewController(vc, animated: true)
                    owner.reactor?.action.onNext(.clearRouting)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.cooking.name }
            .distinctUntilChanged()
            .bind(to: cookingView.naviTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.cooking.imageFileURL }
            .distinctUntilChanged()
            .bind(with: self) { owner, urlString in
                
                let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(urlString ?? "")
                let savedImage = UIImage(contentsOfFile: filePath.path)
                
                owner.cookingView.thumbImageView.image = savedImage ?? .placeholderSmall
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.cooking.memo }
            .distinctUntilChanged()
            .bind(to: cookingView.memoTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.cooking.rating }
            .distinctUntilChanged()
            .bind(with: self) { owner, rating in
                owner.cookingView.ratingView.rating = rating ?? 0
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.showDeleteAlert }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "삭제하기", message: "이 요리를 삭제하시겠습니까?", button: "삭제", style: .destructive, isCancelButton: true) {
                    owner.reactor?.action.onNext(.confirmDeleteTapped)
                }
                owner.reactor?.action.onNext(.clearShowAlert)
            }
            .disposed(by: disposeBag)
    }
}
