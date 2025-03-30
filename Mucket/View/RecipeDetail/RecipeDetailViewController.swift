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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableViewHeight()
    }
    
    override func loadView() {
        view = recipeDetailView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureData() {
        recipeDetailView.makingTableView.delegate = self
        recipeDetailView.makingTableView.dataSource = self
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
        bindState(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: RecipeDetailReactor) {
        
    }
    
    private func bindState(_ reactor: RecipeDetailReactor) {
        
    }
}

// TODO: Rx로 구현
extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.id, for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
