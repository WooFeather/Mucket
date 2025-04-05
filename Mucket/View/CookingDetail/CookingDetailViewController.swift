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
                    print("수정뷰로 이동")
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
                let savedImage = UIImage(contentsOfFile: urlString ?? "")
                if savedImage == nil {
                    print("이미지를 로드할 수 없습니다.")
                }
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
    }
}
