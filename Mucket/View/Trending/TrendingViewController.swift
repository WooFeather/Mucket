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
}
