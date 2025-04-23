//
//  RecipeDetailViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/30/25.
//

import UIKit
import SnapKit
import ReactorKit
import RxCocoa
import Toast

final class RecipeDetailViewController: BaseViewController {
    
    private let recipeDetailView = RecipeDetailView()
    var disposeBag = DisposeBag()
    
    init(reactor: RecipeDetailReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = recipeDetailView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
}

// MARK: - Reactor
extension RecipeDetailViewController: View {
    func bind(reactor: RecipeDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: RecipeDetailReactor) {
        recipeDetailView.backButton.rx.tap
            .map { RecipeDetailReactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        recipeDetailView.bookmarkButton.rx.tap
            .map { RecipeDetailReactor.Action.bookmarkButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        recipeDetailView.bookmarkButton.rx.tap
            .withLatestFrom(reactor.state.map(\.isBookmarked))
            .bind(with: self) { owner, isBookmarked in
                let message = isBookmarked ? "북마크에 추가되었습니다" : "북마크에서 삭제되었습니다"
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = scene.windows.first(where: { $0.isKeyWindow }) {
                    window.makeToast(message)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: RecipeDetailReactor) {
        reactor.state
            .map{ $0.shouldPopToPrevView }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.recipe.name }
            .distinctUntilChanged()
            .bind(to: recipeDetailView.naviTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.recipe.imageURL }
            .distinctUntilChanged()
            .map { $0.toHTTPS() }
            .compactMap(URL.init(string:))
            .bind(with: self) { [weak self] owner, url in
                Task {
                    let image = try await ImageCacheManager.shared
                        .load(url: url, saveOption: .onlyMemory, thumbSize: self?.recipeDetailView.thumbImageView.bounds.size ?? CGSize(width: 110, height: 78))
                    await MainActor.run {
                        owner.recipeDetailView.thumbImageView.image = image
                    }
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.recipe.ingredients }
            .distinctUntilChanged()
            .bind(to: recipeDetailView.ingredientTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.recipe }
            .bind(with: self) { owner, recipe in
                owner.recipeDetailView.carInfoView.valueLabel.text = recipe.carbs
                owner.recipeDetailView.proInfoView.valueLabel.text = recipe.protein
                owner.recipeDetailView.fatInfoView.valueLabel.text = recipe.fat
                owner.recipeDetailView.naInfoView.valueLabel.text = recipe.sodium
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.manualSteps }
            .distinctUntilChanged()
            .bind(with: self) { owner, steps in
                owner.recipeDetailView.makingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                
                for step in steps {
                    let stepView = DetailStepView()
                    stepView.configureData(step: step)
                    owner.recipeDetailView.makingStackView.addArrangedSubview(stepView)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isBookmarked }
            .distinctUntilChanged()
            .bind(with: self) { owner, isBookmarked in
                let image = isBookmarked ? UIImage.bookmarkFill : UIImage.bookmark
                owner.recipeDetailView.bookmarkButton.setImage(image, for: .normal)
            }
            .disposed(by: disposeBag)
    }
}

