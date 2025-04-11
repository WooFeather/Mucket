//
//  PlaceDetailViewController.swift
//  Mucket
//
//  Created by 조우현 on 4/11/25.
//

import UIKit
import ReactorKit

final class PlaceDetailViewController: BaseViewController {
    private let placeDetailView = PlaceDetailView()
    
    override func loadView() {
        view = placeDetailView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
}
