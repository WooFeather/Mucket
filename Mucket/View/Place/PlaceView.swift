//
//  RestaurantMapView.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import UIKit
import SnapKit
import KakaoMapsSDK

final class PlaceView: BaseView {
    let mapView = KMViewContainer()
    let currentLocationButton = UIButton()
    
    override func configureHierarchy() {
        [mapView, currentLocationButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.size.equalTo(50)
        }
    }
    
    override func configureView() {
        currentLocationButton.layer.cornerRadius = 25
        currentLocationButton.clipsToBounds = true
        currentLocationButton.backgroundColor = .themePrimary
        currentLocationButton.setImage(.location, for: .normal)
        currentLocationButton.tintColor = .backgroundPrimary
    }
}
