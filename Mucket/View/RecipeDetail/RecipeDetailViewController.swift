//
//  RecipeDetailViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/30/25.
//

import UIKit

final class RecipeDetailViewController: BaseViewController {
    
    private let recipeDetailView = RecipeDetailView()
    
    override func loadView() {
        view = recipeDetailView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        recipeDetailView.makingTableView.layoutIfNeeded()
//        let tableHeight = recipeDetailView.makingTableView.contentSize.height
//
//        recipeDetailView.makingTableView.snp.updateConstraints {
//            $0.height.equalTo(tableHeight)
//        }
//    }
}
