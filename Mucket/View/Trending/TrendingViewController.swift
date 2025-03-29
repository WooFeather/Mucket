//
//  ViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import SnapKit

final class TrendingViewController: BaseViewController {
    private let trendingView = TrendingView()
    
    override func loadView() {
        view = trendingView
    }
    
    override func configureData() {
        trendingView.recommendCollectionView.delegate = self
        trendingView.recommendCollectionView.dataSource = self
        trendingView.themeCollectionView.delegate = self
        trendingView.themeCollectionView.dataSource = self
        trendingView.recommendCollectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCollectionViewCell.id)
        trendingView.themeCollectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCollectionViewCell.id)
    }
}

extension TrendingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.id, for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
