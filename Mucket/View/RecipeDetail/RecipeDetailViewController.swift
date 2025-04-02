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
    
    override func configureData() {
        recipeDetailView.makingTableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.id)
    }
    
    private func updateTableViewHeight() {
        recipeDetailView.makingTableView.reloadData()
        
        DispatchQueue.main.async {
            self.recipeDetailView.makingTableView.layoutIfNeeded()
            let height = self.recipeDetailView.makingTableView.contentSize.height

            self.recipeDetailView.makingTableView.snp.updateConstraints {
                $0.height.equalTo(height)
            }
        }
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
            .map { $0.recipe.imageURL }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self) { owner, urlString in
                let imageURL = URL(string: urlString.toHTTPS())
                Task {
                    do {
                        let image = try await ImageCacheManager.shared.load(url: imageURL, saveOption: .onlyMemory)
                        owner.recipeDetailView.thumbImageView.image = image
                    } catch {
                        print("이미지 로드 실패")
                        owner.recipeDetailView.thumbImageView.image = .placeholderSmall
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
            .bind(to: recipeDetailView.makingTableView.rx.items(
                cellIdentifier: DetailTableViewCell.id,
                cellType: DetailTableViewCell.self
            )) { index, step, cell in
                cell.configureData(step: step)
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

