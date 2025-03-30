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
    
    override func configureData() {
        cookingView.myCookingCollectionView.register(CookingCollectionViewCell.self, forCellWithReuseIdentifier: CookingCollectionViewCell.id)
        cookingView.myCookingCollectionView.delegate = self
        cookingView.myCookingCollectionView.dataSource = self
    }
}

extension CookingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CookingCollectionViewCell.id, for: indexPath) as? CookingCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
