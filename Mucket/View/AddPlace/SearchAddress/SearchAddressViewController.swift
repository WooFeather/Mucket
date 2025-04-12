//
//  SearchAddressViewController.swift
//  Mucket
//
//  Created by 조우현 on 4/9/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class SearchAddressViewController: BaseViewController {
    
    private let searchAddressView = SearchAddressView()
    var disposeBag = DisposeBag()
    var onAddressSelected: ((PlaceDetail) -> Void)?
    
    init(reactor: SearchAddressReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchAddressView.searchBar.textField.becomeFirstResponder()
    }
    
    override func loadView() {
        view = searchAddressView
    }
    
    override func configureView() {
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureData() {
        searchAddressView.addressTableView.register(UITableViewCell.self, forCellReuseIdentifier: "addressTableViewCell")
    }
}

// MARK: - Reactor
extension SearchAddressViewController: View {
    func bind(reactor: SearchAddressReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: SearchAddressReactor) {
        searchAddressView.closeButton.rx.tap
            .map { SearchAddressReactor.Action.closeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchAddressView.searchBar.textField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(searchAddressView.searchBar.textField.rx.text.orEmpty)
            .map { SearchAddressReactor.Action.searchButtonTapped(query: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchAddressView.addressTableView.rx.modelSelected(PlaceDetail.self)
            .bind(with: self) { owner, place in
                owner.onAddressSelected?(place)
                owner.reactor?.action.onNext(.searchCellTapped(place: place))
            }
            .disposed(by: disposeBag)
        
        // 페이지네이션
        searchAddressView.addressTableView.rx.willDisplayCell
            .map { (cell, indexPath) -> Bool in
                let itemCount = reactor.currentState.searchResult.count
                return indexPath.row == itemCount - 1
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in SearchAddressReactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ rector: SearchAddressReactor) {
        reactor?.state
            .map { $0.shouldPopToPrevView }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor?.state
            .map { $0.isSearchTableViewHidden }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isHidden in
                owner.searchAddressView.addressTableView.isHidden = isHidden
                if !isHidden {
                    owner.searchAddressView.searchBar.textField.resignFirstResponder()
                }
            }
            .disposed(by: disposeBag)
        
        rector.state
            .map { $0.isEmptyStateHidden }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isHidden in
                owner.searchAddressView.emptyStateView.isHidden = isHidden
                if !isHidden {
                    owner.searchAddressView.addressTableView.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        reactor?.state
            .map { $0.searchResult }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: searchAddressView.addressTableView.rx.items) { tableView, index, entity in
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "addressTableViewCell")
                cell.backgroundColor = .clear
                cell.textLabel?.text = entity.placeName
                cell.textLabel?.font = .Body.body2
                cell.textLabel?.textColor = .textPrimary
                cell.detailTextLabel?.text = entity.roadAddressName
                cell.detailTextLabel?.font = .Body.body5
                cell.detailTextLabel?.textColor = .textSecondary
                return cell
            }
            .disposed(by: disposeBag)
        
        reactor?.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isLoading in
                if isLoading {
                    owner.searchAddressView.loadingIndicator.startAnimating()
                } else {
                    owner.searchAddressView.loadingIndicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
        
        reactor?.state
            .map { $0.alertMessage }
            .distinctUntilChanged()
            .compactMap { $0 } // nil 제거
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, message in
                owner.showAlert(title: "검색실패!", message: message, button: "확인") {
                    owner.dismiss(animated: true)
                }
                owner.reactor?.action.onNext(.clearAlert)
            }
            .disposed(by: disposeBag)
    }
}
