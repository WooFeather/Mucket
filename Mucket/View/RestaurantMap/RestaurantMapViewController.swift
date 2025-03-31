//
//  RestaurantMapViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import Foundation

final class RestaurantMapViewController: BaseViewController {
    private let restaurantMapView = RestaurantMapView()
    
    override func loadView() {
        view = restaurantMapView
    }
    
    override func configureView() {
        view.backgroundColor = .backgroundPrimary
    }
}
