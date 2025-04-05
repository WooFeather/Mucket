//
//  RecipeViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class CookingViewController: BaseViewController {
    private let cookingView = CookingView()
    var disposeBag = DisposeBag()
    
    init(reactor: CookingReactor) {
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
            .map { CookingReactor.Action.fetchCookings }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = cookingView
    }
    
    override func configureData() {
        cookingView.myCookingCollectionView.register(CookingCollectionViewCell.self, forCellWithReuseIdentifier: CookingCollectionViewCell.id)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFolderMenu),
            name: NSNotification.Name("FolderListUpdated"),
            object: nil
        )
    }
    
    @objc private func updateFolderMenu() {
        // 컨텍스트 메뉴 업데이트
        cookingView.updateFolderMenu()
    }
}

extension CookingViewController: View {
    func bind(reactor: CookingReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: CookingReactor) {
        cookingView.didSelectFolder = { folderId in
            reactor.action.onNext(.filterByFolder(folderId: folderId))
        }
        
        cookingView.myCookingCollectionView.rx.modelSelected(MyCookingEntity.self)
            .map { CookingReactor.Action.cookingCellTapped($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: CookingReactor) {
        reactor.state
            .map { $0.filteredCookings }
            .distinctUntilChanged()
            .bind(to: cookingView.myCookingCollectionView.rx.items(cellIdentifier: CookingCollectionViewCell.id, cellType: CookingCollectionViewCell.self)) { row, entity, cell in
                cell.configureData(entity: entity)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, route in
                switch route {
                case .detail(let cooking):
                    let vc = CookingDetailViewController(reactor: CookingDetailReactor(cooking: cooking, repository: MyCookingRepository()))
                    vc.hidesBottomBarWhenPushed = true
                    owner.navigationController?.pushViewController(vc, animated: true)
                    owner.reactor?.action.onNext(.clearRouting)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
