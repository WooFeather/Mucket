//
//  RecipeViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit

final class CookingViewController: BaseViewController {
    private let cookingView = CookingView()
    
    override func loadView() {
        view = cookingView
    }
}
