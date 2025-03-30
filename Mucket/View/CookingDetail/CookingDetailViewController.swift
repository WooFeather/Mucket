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
        bindState(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: CookingDetailReactor) {
        
    }
    
    private func bindState(_ reactor: CookingDetailReactor) {
        
    }
}
